//
//  RecordInfoDatabaseService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 12/03/23.
//

import Foundation

class RecordInfoDatabaseService {
    
    
    private let database = Database.shared
    
    func createIndividualRecordTable(tableName: String, columns: [String]) {
        
        var modifiedColumns = [String]()
        
        if columns.isEmpty == false {
            
            for index in 0 ..< columns.count {
                
                var modifiedColumn = columns[index].appending(DatabaseService.sqliteText)
                
                if index == 0 {
                    
                    modifiedColumn.append(DatabaseService.primaryKey)
                }
                
                modifiedColumns.append(modifiedColumn)
            }
        }
        
        if database.createTable(tableName: tableName, columns: modifiedColumns) == false {
            
//            print(database.errorMsg)
        }
    }
    
    func saveIndividualRecordData(tableName: String, columns: [String], data: [String]) {
        
        var record = [String: Any]()
        for index in 0 ..< columns.count {
            
            record[columns[index]] = data[index]
        }
        
        if database.insert(tableName: tableName, values: record) == false {
//            print(database.errorMsg)
        }
    }
    
    func getrecordById(recordId: String,
                       module: String,
                       completion: @escaping ([String: Any]) -> Void) -> Void {
        
        let whereClause = "id = '\(recordId)'"
        var recordInfo = [String: Any]()
        let dispatchGroup = DispatchGroup()
        
        database.select(tableName: module, whereClause: whereClause) { [weak self] result in
            
            guard let record = result?.first else {
                
                print("No record found for id")
                return
            }
            
            let suffix = "Id"
            
            for (key, value) in record {
                
                var modifiedKey = key
                
                if key.hasSuffix(suffix) {
                    
                    modifiedKey = String(key.prefix(key.count - suffix.count))
                    
                    recordInfo[modifiedKey] = [value, ""]
                    self?.getLookupData(tableName: modifiedKey, id: value as! String) { lookupData in
                        if let newValue = lookupData {
                            
                            recordInfo[modifiedKey] = newValue
                        }
                    }
                } else {
                    
                    recordInfo[modifiedKey] = value
                }
            }
            
            completion(recordInfo)
        }
    }
    
    private func getLookupData(tableName: String,
                               id: String,
                               completion: @escaping ([String]?) -> Void) -> Void {
        
        let whereClause = "id = '\(id)'"
        var lookupData = [String]()
        
        database.select(tableName: tableName ,whereClause: whereClause) { result in
            
            guard let data = result?[0],
                  let id = data["id"] as? String,
                  let name = data["Name"] as? String else
            {
                print("no lookupData found")
                completion(nil)
                return
            }
            
            lookupData.append(id)
            lookupData.append(name)
            
            completion(lookupData)
        }
    }
}
