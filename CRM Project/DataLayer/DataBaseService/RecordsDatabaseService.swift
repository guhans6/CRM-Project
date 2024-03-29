//
//  RecordsDatabaseService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 09/03/23.
//

import Foundation
import UIKit

class RecordsDatabaseService {
    
    // Records Table Column
    private let recordsTableName = "Records"
    private let recordIdColumn = "record_id"
    private let recordNameColumn = "record_name"
    private let secondaryDataColumn = "secondary_data"
    private let recordModule = "recordModule"
    private let recordImageColumn = "recordImage"
    
    private let database = Database.shared
    
    func createRecordsTable() {
        
        let columns = [
            recordIdColumn.appending("\(DatabaseService.text) PRIMARY KEY"),
            recordNameColumn.appending(DatabaseService.text),
            secondaryDataColumn.appending(DatabaseService.text),
            recordModule.appending(DatabaseService.text),
            recordImageColumn.appending(DatabaseService.blob)
        ]

        if database.createTable(tableName: recordsTableName, columns: columns) == false {

            print(database.errorMsg)
        }
    }
    
    func saveRecordInDatabase(record: Record, moduleApiName: String) {
        
        
        var recordDictionary = [String: Any]()
        
        recordDictionary[recordIdColumn] = record.recordId
        recordDictionary[recordNameColumn] = record.recordName
        recordDictionary[secondaryDataColumn] = record.secondaryRecordData
        recordDictionary[recordModule] = moduleApiName
        
        if let image = record.recordImage {
            recordDictionary[recordImageColumn] = image.pngData()
        }
        
        if database.insert(tableName: recordsTableName, values: recordDictionary) == false {
            
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
            
            if database.delete(tableName: recordsTableName,
                                       whereClause: whereClause, whereArgs: whereArgs) == false {
                print(Database.shared.errorMsg)
            } else {
                print("record delete Success")
            }
        }
    }
    
    func deleteRecordTable() {
        
        if database.drop(tableName: recordsTableName) == false {
            print(database.errorMsg)
        }
    }
}

extension RecordsDatabaseService {
    
    func getRecordImage(module: String, id: String, completion: @escaping (Data) -> Void) {
        
        database.select(tableName: recordsTableName,
                        whereClause: "\(recordIdColumn) = ?",
                        args: [id],
                        select: recordImageColumn) { [weak self] results in
            
            guard let recordImage = self?.recordImageColumn else {
                print("No record Image")
                return
            }
            
            if let result = results?.first, let recordImage = result[recordImage] as? Data {
                // Use the recordImage data
                completion(recordImage)
            } else {
                print("No record Image")
            }
        }

    }
}

extension RecordsDatabaseService {
    
    func saveImage(image: UIImage?, module: String, recordId: String, completion: @escaping (Bool) -> Void) {
        
        let whereClause = "\(recordIdColumn) = ?"
        let whereArgs = [recordId]
        let imageData = image?.pngData()
        let setClause: [String: Any] = [recordImageColumn: imageData as Any]
        
        if database.update(tableName: recordsTableName, values: setClause, whereClause: whereClause, whereArgs: whereArgs) {
            print("Image set successfully")
        } else {
            print("can't update image")
        }
    }
    
    func deleteImage(module: String, recordId: String, completion: @escaping (Bool) -> Void) {
        
        let whereClause =  "\(recordIdColumn) = ?"
        
        if database.delete(tableName: recordsTableName, whereClause: whereClause, whereArgs: [recordId]) {
            
            print("Image deleted successfully")
        } else {
            print("can't delete image")
        }
    }
}
