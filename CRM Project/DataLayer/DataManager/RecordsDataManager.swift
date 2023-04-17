//
//  RecordsDataManager.swift
//  CRM C
//
//  Created by guhan-pt6208 on 19/02/23.
//

import Foundation
import UIKit

class RecordsDataManager {
    
    private let tableName = "Records"
    private let recordIdColumn = "record_id"
    private let recordNameColumn = "record_name"
    private let secondaryDataColumn = "secondary_data"
    private let recordImageColumn = "recordImage"
    
    private let recordsNetworkService = RecordsNetworkService()
    private let recordsDatabaseService = RecordsDatabaseService()
    private let recordInfoDatabaseService = RecordInfoDatabaseService()
    private let fieldsDataManager = FieldsDataManager()
    private var count = 0
    
    func addRecord(module: String,
                   recordData: [String: Any?],
                   isAUpdate: Bool,
                   recordId: String?,
                   isRecordSaved: @escaping (Bool) -> Void ) -> Void {
        
        recordsNetworkService.addRecord(module: module, recordData: recordData, isAUpdate: isAUpdate, recordId: recordId) { isASuccess in
            
            isRecordSaved(isASuccess)
        }
    }
    
    func getRecords(module: String,
                    completion: @escaping ([Record]) -> Void) -> Void {

        self.getRecordsFromDatabase(module: module) { records in

            completion(records)
        }
        
        self.getRecordsFromNetwork(module: module) { records in
            
            completion(records)
        }
    }
    
    private func getRecordsFromDatabase(module: String,
                                        completion: @escaping ([Record]) -> Void) -> Void {
        
        recordsDatabaseService.getAllRecordsFromDataBase(module: module) {  recordResult in
            
            var recordsArray = [Record]()
            recordResult.forEach { record in
                
                
                let convertedRecord = self.convertRecord(record: record)
                
                recordsArray.append(convertedRecord)
            }
            
            completion(recordsArray)
        }
    }
    
    private func getRecordsFromNetwork(module: String, completion: @escaping ([Record]) -> Void) -> Void {
        
        recordsNetworkService.getRecords(module: module, id: nil) { [weak self] recordsResult, error in
            
            var recordsArray = [Record]()
            
            if let error = error {
                
                if let networkError = error as? NetworkError, networkError == .emptyDataError {
                    
                    completion(recordsArray)
                } else {
                    print(error.localizedDescription)
                }
                return
            }
            
            guard let recordsResult = recordsResult else {
                return
            }
            
            recordsResult.forEach { record in
                
                var secondaryData = ""
                
                if let email = record["Email"] as? String {
                    
                    secondaryData = email
                }
                
                guard let recordName = record["Name"] as? String,
                      let recordId = record["id"] as? String
                else {
                    print("Invalid Record Info")
                    return
                }
                
                let record = Record(recordName: recordName,
                                    secondaryRecordData: secondaryData,
                                    recordId: recordId, recordImage: nil)
                
                recordsArray.append(record)
//                self?.recordsDatabaseService.saveRecordInDatabase(record: record,
//                                                            moduleApiName: module)
            }
//            completion(recordsArray)
            var recordsWithImages = [Record]()
            var recordDictionary = [Int: Record]()
            var count = 0

            for i in 0 ..< recordsArray.count {

                let record = recordsArray[i]
                self?.recordsNetworkService.getRecordImage(module: module,
                                                           id: record.recordId,
                                                           completion: { resultImage in
                    count += 1
                    var recordCopy = record
                    recordCopy.recordImage = resultImage

                    recordsWithImages.append(recordCopy)

                    recordDictionary[i] = recordCopy

                    if count == recordsArray.count {

                        for i in 0 ..< recordsArray.count {

                            recordsWithImages[i] = recordDictionary[i]!
                            self?.recordsDatabaseService.saveRecordInDatabase(record: recordsWithImages[i],
                                                                        moduleApiName: module)
                        }
                        completion(recordsWithImages)
                    }
                })
            }
        }
    }
    
    private func convertRecord(record: [String: Any]) -> Record {
        
        let recordId = record[recordIdColumn] as! String
        let recordName = record[recordNameColumn] as! String
        let secodaryData = record[secondaryDataColumn] as! String
        
        var recordImage: UIImage? = nil
        
        if let imageData = record[recordImageColumn] as? Data {
            if recordName == "Deepak" {
                print(0)
            }
            recordImage = UIImage(data: imageData)
        }

        return Record(recordName: recordName,
                      secondaryRecordData: secodaryData,
                      recordId: recordId,
                      recordImage: recordImage)
    }
    
    func getRecordById(module: String,
                       id: String,
                       fields: [Field],
                       completion: @escaping ([(String, Any)]) -> Void) -> Void {
        
        self.getRecordFromDatabase(module: module, id: id, fields: fields) { recordData in
            
            completion(recordData)
        }
      
        self.getRecordFromNetwork(module: module, id: id, fields: fields) { recordData in
            
            completion(recordData)
        }
    }
    
    private func getRecordFromDatabase(module: String,
                                       id: String,
                                       fields: [Field],
                                       completion: @escaping ([(String, Any)]) -> Void) -> Void {
        
        self.recordInfoDatabaseService.getrecordById(recordId: id, module: module) { recordData in

            var recordInfo = [(String, Any)]()

            for field in fields {

                for (key, value) in recordData {

                    if  field.apiName == key || field.fieldLabel == key {

                        if field.displayLabel == "CustomModule Name" {
                            recordInfo.append(("Name", value))
                        } else {
                            recordInfo.append((field.displayLabel, value))
                        }
                    }
                }
            }

            completion(recordInfo)
        }
    }
    
    private func getRecordFromNetwork(module: String,
                                      id: String,
                                      fields: [Field],
                                      completion: @escaping ([(String, Any)]) -> Void) -> Void {
        
        self.recordsNetworkService.getIndividualRecord(module: module, id: id) { [weak self] record in
            
            var recordInfo = [(String, Any)]()
            var columns = ["id"]
            
            var databaseData = [id]
            
            for field in fields {
                
                for (key, value) in record {
                    
                    if field.fieldLabel == key || field.apiName == key {
                        
                        let isLookup = field.lookup.module != nil
                        
                        if !key.starts(with: "$") && key != "Locked__s" {
                            if let recordDictionary = value as? [String: Any] {
                                
                                let name = recordDictionary["name"] as! String
                                let id = recordDictionary["id"] as! String
                                
                                databaseData.append(id)
                                recordInfo.append((field.displayLabel, [id, name]))
                                
                            } else if let value = value as? Bool {
                                
                                let data = value == true ? "Yes" : "No"
                                
                                databaseData.append(data)
                                recordInfo.append((field.displayLabel, data))
                            } else if let recordArray = value as? [String] {
                                
                                let data = recordArray.joined(separator: ", ")
                                
                                databaseData.append(data)
                                recordInfo.append((field.displayLabel, data))
                            } else if let doubleValue = value as? Double {
                                
                                let data = String(doubleValue)
                                databaseData.append(data)
                                
                                recordInfo.append((field.displayLabel, data))
                            } else if let intValue = value as? Int {
                                
                                let data = String(intValue)
                                databaseData.append(data)
                                
                                recordInfo.append((field.displayLabel, data))
                            } else {
                                
                                let modifiedValue = value as? String ?? ""
                                let dateOrText = self?.convert(date: modifiedValue)
                                
                                databaseData.append(dateOrText ?? modifiedValue)
                                
                                if field.displayLabel == "CustomModule Name" {
                                    recordInfo.append(("Name", dateOrText ?? modifiedValue))
                                } else {
//                                    recordInfo.append((field.displayLabel, value))
                                    recordInfo.append((field.displayLabel, dateOrText ?? modifiedValue))
                                }
                            }
                            
                            var column = field.apiName
                            if isLookup {
                                
                                column = column.appending("Id")
                            }
                            if column == "From" || column == "To" {
                                column = "'\(column)'"
                            }
                            columns.append(column)
                        }
                        break
                    }
                }
            }
            completion(recordInfo)
            
            self?.recordInfoDatabaseService
                .createIndividualRecordTable(tableName: module, columns: columns)
            
            self?.recordInfoDatabaseService.saveIndividualRecordData(tableName: module, columns: columns, data: databaseData)
        }
    }
    
    private func getField(module: String) -> [Field] {
        
        var fieldsRecord = [Field]()
        self.fieldsDataManager.getfieldMetaData(module: module) { fields in
            fieldsRecord = fields
        }
        
        return fieldsRecord
    }
    
    // MARK: RETURN SUCCESS OR FAILIURE
    func deleteRecords(module: String, ids: [String], completion: @escaping (Bool) -> Void) -> Void {
        
        recordsDatabaseService.deleteRecordInDatabase(module: module, ids: ids)
        
        recordsNetworkService.deleteRecords(module: module, ids: ids) { data in
            completion(data)
        }
        
        
    }
    
    private func convert(date: String) -> String {
        
        /// Regex pattern to identify date
        let dateRegex = #"^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2]\d|3[0-1])$"#
        
        if let _ = date.range(of: dateRegex, options: .regularExpression) {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let date = dateFormatter.date(from: date) {
                
                let formattedDate = DateFormatter.formattedString(from: date, format: "dd-MM-yyyy")
                
                return formattedDate
            } else {
                
                // the string is invalid
                print("Invalid date string")
            }
        }
        return date
    }
}

extension RecordsDataManager {
    
    func getRecordImage(module: String, recordId: String, completion: @escaping (UIImage?) -> Void) {

        recordsDatabaseService.getRecordImage(module: module, id: recordId) { imageData in

            if let image = UIImage(data: imageData) {
                print(9)
            }
            completion(UIImage(data: imageData))
        }
//
        recordsNetworkService.getRecordImage(module: module, id: recordId) { image in
            completion(image)
        }
    }
}

extension RecordsDataManager {
    
    func uploadImage(image: UIImage?, module: String, recordId: String, completion: @escaping (Bool) -> Void) {
        
        recordsDatabaseService.saveImage(image: image, module: module, recordId: recordId) { isSuccess in
//            completion
        }
        
        recordsNetworkService.uploadImage(photoData: image, module: module, recordId: recordId) { isSuccess in
            completion(isSuccess)
        }
    }
    
    func deleteImage(module: String, recordId: String, completion: @escaping (Bool) -> Void) {
        
        recordsDatabaseService.deleteImage(module: module, recordId: recordId) { isSuccess in
            print(isSuccess, "DB")
        }
        
        recordsNetworkService.removeImage(module: module, recordId: recordId) { isSuccess in
            
            completion(isSuccess)
        }
        
        
    }
}
