//
//  RecordsDatabaseService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 09/03/23.
//

import Foundation

class RecordsDatabaseService {
    
    // Records Table Column
    private let recordsTableName = "Records"
    private let recordIdColumn = "record_id"
    private let recordNameColumn = "record_name"
    private let secondaryDataColumn = "secondary_data"
    private let recordModule = "recordModule"
    
    private let database = Database.shared
    
    func createRecordsTable() {
        
        let columns = [
            recordIdColumn.appending("\(DatabaseService.sqliteText) PRIMARY KEY"),
            recordNameColumn.appending(DatabaseService.sqliteText),
            secondaryDataColumn.appending(DatabaseService.sqliteText),
            recordModule.appending(DatabaseService.sqliteText)
        ]

        if database.createTable(tableName: recordsTableName, columns: columns) == false {

            print(database.errorMsg)
        }
    }
    
    func saveRecordsInDatabase(record: Record, moduleApiName: String) {
        
        
        var recordDictionary = [String: Any]()
        
        recordDictionary[recordIdColumn] = record.recordId
        recordDictionary[recordNameColumn] = record.recordName
        recordDictionary[secondaryDataColumn] = record.secondaryRecordData
        recordDictionary[recordModule] = moduleApiName
        
        if !database.insert(tableName: recordsTableName, values: recordDictionary) {
            
            print(Database.shared.errorMsg)
        }
    }
    
    func getAllRecordsFromDataBase(module: String,
                                   completion: @escaping ([[String: Any]]) -> Void) -> Void
    {
        
        database.select(tableName: recordsTableName,
                               whereClause: "\(recordModule) = '\(module)'") {[weak self] result in
            
            guard let result = result else {
                let errMsg = self?.database.errorMsg
                print("Record DB fetch error \(errMsg ?? "")")
                return
            }
            completion(result)
        }
    }
    
    func deleteRecordInDatabase(module: String, ids: [String]) {
        
        let whereClause = "\(recordIdColumn) = ? AND \(recordModule) = ?"
        
        ids.forEach { id in
            let whereArgs = [id, module]
            
            if !database.delete(tableName: recordsTableName,
                                       whereClause: whereClause, whereArgs: whereArgs) {
                print(Database.shared.errorMsg)
            }
        }
        
    }
    
    func createIndividualRecordTable(tableName: String, columns: [String]) {
        
        if database.createTable(tableName: tableName, columns: columns) == false {

            print(database.errorMsg)
        }
    }
}
