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
    
    func saveAllRecordsInDatabase(records: [Record], moduleApiName: String) {
        
        for record in records {
            
            var recordDictionary = [String: Any]()
            
            recordDictionary[recordIdColumn] = record.recordId
            recordDictionary[recordNameColumn] = record.recordName
            recordDictionary[secondaryDataColumn] = record.secondaryRecordData
            recordDictionary[recordModule] = moduleApiName
            
            if Database.shared.insert(tableName: "Records", values: recordDictionary) {
                print("Records added to db")
            } else {
                print(Database.shared.errorMsg)
            }
        }
    }
    
    func getAllRecordsFromDataBase(module: String,
                                   completion: @escaping ([[String: Any]]) -> Void) -> Void
    {
        
        Database.shared.select(tableName: recordsTableName,
                               whereClause: "\(recordModule) = '\(module)'") { result in
            
            guard let result = result else {
                print("No records in database")
                return
            }
            completion(result)
        }
    }
}
