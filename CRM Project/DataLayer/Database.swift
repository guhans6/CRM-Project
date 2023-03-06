//
//  Database.swift
//  CRM C
//
//  Created by guhan-pt6208 on 02/03/23.
//

import Foundation
import SQLite3

class Database {
    
    static let shared = Database()
    private var dbPointer: OpaquePointer?
    
    private let fileURL = try! FileManager.default
        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("crm.sqlite")
    
    /// Get the recent error mesasg
    var errorMsg: String {
        get {
        
            if let error = sqlite3_errmsg(dbPointer) {
                let errorMsg = String(cString: error)
                return errorMsg
            } else {
                return "No error message recieved"
            }
        }
    }
    
    private init() {
        openDatabase()
    }
    
    private func openDatabase() {
        
        if sqlite3_open(fileURL.path, &dbPointer) != SQLITE_OK {
            print("error opening database")
        } else {
            print("opened succesfully \(fileURL.absoluteURL)")
        }
    }
    
    func execute(query: String, values: [Any] = []) -> Bool {
        var success = false
        var db: OpaquePointer?
        
        // Open the database
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            
            var statement: OpaquePointer?
            
            // Prepare the statement
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                
                // Bind the values to the statement
                for (index, value) in values.enumerated() {
                    let parameterIndex = Int32(index + 1)
                    
                    if let stringValue = value as? String {
//                        print(stringValue)
                        sqlite3_bind_text(statement, parameterIndex, NSString(string: stringValue).utf8String, -1, nil)
                    } else if let intValue = value as? Int {
                        sqlite3_bind_int(statement, parameterIndex, Int32(intValue))
                    } else if let doubleValue = value as? Double {
                        sqlite3_bind_double(statement, parameterIndex, doubleValue)
                    } else if let dataValue = value as? Data {
                        sqlite3_bind_blob(statement, parameterIndex, (dataValue as NSData).bytes, Int32(dataValue.count), nil)
                    } else if let boolValue = value as? Bool {
                        let boolIntValue = boolValue ? 1 : 0
                        sqlite3_bind_int(statement, parameterIndex, Int32(boolIntValue))
                    } else {
                        // Unsupported data type
                        print("unspported data type")
                        break
                    }
                }
                
                // Execute the statement
                if sqlite3_step(statement) == SQLITE_DONE {
                    success = true
                }
            } else {
                print(sqlite3_errmsg(db)!)
            }
            
            // Finalize the statement
            sqlite3_finalize(statement)
        }
        
        // Close the database
//        sqlite3_close(db)
        
        return success
    }

    
    func createTable(tableName: String, columns: [String]) -> Bool {
        let columnsStr = columns.joined(separator: ", ")
        let createQuery = "CREATE TABLE IF NOT EXISTS \(tableName) (\(columnsStr));"
//        print(createQuery)
        return execute(query: createQuery)
    }
    
    func insert(tableName: String, values: [String: Any]) -> Bool {
        
        if !values.isEmpty {
            let columns = values.keys.joined(separator: ", ")
            let placeholders = Array(repeating: "?", count: values.count).joined(separator: ", ")
            let valuesArr = Array(values.values)
            let insertQuery = "INSERT OR REPLACE INTO \(tableName) (\(columns)) VALUES (\(placeholders))"
            return execute(query: insertQuery, values: valuesArr)
        }
        print("Empty values can't be inserted")
        return false
    }
    
    func update(tableName: String, values: [String: Any], whereClause: String, whereArgs: [Any]?) -> Bool {
        let setClause = values.map({ "\($0.key)=?" }).joined(separator: ", ")
        let updateQuery = "UPDATE \(tableName) SET \(setClause) WHERE \(whereClause)"
        var valuesArr = Array(values.values)
        if let whereArgs = whereArgs {
            valuesArr.append(contentsOf: whereArgs)
        }
//        print(updateQuery)
        return execute(query: updateQuery, values: valuesArr)
    }
    
    func delete(tableName: String, whereClause: String, whereArgs: [Any]?) -> Bool {
        let deleteQuery = "DELETE FROM \(tableName) WHERE \(whereClause)"
        return execute(query: deleteQuery, values: whereArgs ?? [Any]())
    }
    
    func select(tableName: String,
                whereClause: String? = nil,
                args: [Any]? = nil,
                select: String = "*", addition: String = "") -> [[String: Any]]? {
        
        var results: [[String: Any]]?
        
        let query = """
            SELECT \(select)
            FROM \(tableName)
            \(whereClause != nil ? "WHERE \(whereClause!)" : "")
            \(addition)
            """
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(dbPointer, query, -1, &stmt, nil) == SQLITE_OK {
            if let args = args {
                // Bind the parameters to the statement
                for i in 0..<args.count {
                    if let value = args[i] as? String {
                        sqlite3_bind_text(stmt, Int32(i + 1), value, -1, nil)
                    } else if let value = args[i] as? Int {
                        sqlite3_bind_int(stmt, Int32(i + 1), Int32(value))
                    } else if let value = args[i] as? Double {
                        sqlite3_bind_double(stmt, Int32(i + 1), value)
                    } else if args[i] is NSNull {
                        sqlite3_bind_null(stmt, Int32(i + 1))
                    } else {
                        // Unsupported type
                        sqlite3_finalize(stmt)
                        return nil
                    }
                }
            }
            
            var rows = [[String: Any]]()
            while sqlite3_step(stmt) == SQLITE_ROW {
                var row = [String: Any]()
                for i in 0..<sqlite3_column_count(stmt) {
                    let name = String(cString: sqlite3_column_name(stmt, i))
                    let type = sqlite3_column_type(stmt, i)
                    let value: Any?
                    switch type {
                    case SQLITE_INTEGER:
                        value = Int(sqlite3_column_int(stmt, i))
                    case SQLITE_FLOAT:
                        value = Double(sqlite3_column_double(stmt, i))
                    case SQLITE_TEXT:
                        let cString = sqlite3_column_text(stmt, i)
                        value = String(cString: cString!)
                    case SQLITE_BLOB:
                        let data = sqlite3_column_blob(stmt, i)
                        let size = Int(sqlite3_column_bytes(stmt, i))
                        value = Data(bytes: data!, count: size)
                    case SQLITE_NULL:
                        value = nil
                    default:
                        // Unsupported type
                        sqlite3_finalize(stmt)
                        return nil
                    }
                    row[name] = value
                }
                rows.append(row)
            }
            results = rows
        }
        
        sqlite3_finalize(stmt)
        return results
    }
}
