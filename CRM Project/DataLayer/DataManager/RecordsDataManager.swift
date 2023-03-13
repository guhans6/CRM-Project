//
//  RecordsDataManager.swift
//  CRM C
//
//  Created by guhan-pt6208 on 19/02/23.
//

import Foundation

class RecordsDataManager {
    
    private let tableName = "Records"
    private let recordIdColumn = "record_id"
    private let recordNameColumn = "record_name"
    private let secondaryDataColumn = "secondary_data"
    
    private let recordsNetworkService = RecordsNetworkService()
    private let recordsDatabaseService = RecordsDatabaseService()
    private let recordInfoDatabaseService = RecordInfoDatabaseService()
    private let fieldsDataManager = FieldsDataManager()
    private let queue = DispatchQueue(label: "recordQueue")
    
    func addRecord(module: String,
                   recordData: [String: Any?],
                   isAUpdate: Bool,
                   recordId: String?,
                   isRecordSaved: @escaping (Bool) -> Void ) -> Void {
        
        recordsNetworkService.addRecord(module: module, recordData: recordData, isAUpdate: isAUpdate, recordId: recordId) { isASuccess in
            
            DispatchQueue.main.async {
                isRecordSaved(isASuccess)
            }
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
            
            DispatchQueue.main.async {
                completion(recordsArray)
            }
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
                
                let secondaryData = record["Email"] as? String ?? record["Owner"] as? String ?? ""
                
                guard let recordName = record["Name"] as? String,
                      let recordId = record["id"] as? String
                else {
                    print("Invalid Record Info")
                    return
                }
                
                let record = Record(recordName: recordName,
                                    secondaryRecordData: secondaryData,
                                    recordId: recordId,
                                    owner: nil ,createdTime: nil,
                                    modifiedBy: nil, modifiedTime: nil)
                
                recordsArray.append(record)
                self?.recordsDatabaseService.saveRecordsInDatabase(record: record,
                                                            moduleApiName: module)
            }
            
            
            completion(recordsArray)
            
        }
    }
    
    private func convertRecord(record: [String: Any]) -> Record {
        
        let recordId = record[recordIdColumn] as! String
        let recordName = record[recordNameColumn] as! String
        let secodaryData = record[secondaryDataColumn] as! String
        
        return Record(recordName: recordName, secondaryRecordData: secodaryData, recordId: recordId, owner: nil, createdTime: nil, modifiedBy: nil, modifiedTime: nil)
    }
    
    func getRecordById(module: String,
                       id: String,
                       fields: [Field],
                       completion: @escaping ([(String, Any)]) -> Void) -> Void {
        
            self.recordInfoDatabaseService.getrecordById(recordId: id, module: module) { recordData in
                
                var recordInfo = [(String, Any)]()
                
                for field in fields {
                    
                    for (key, value) in recordData {
                        
                        if  field.apiName == key || field.fieldLabel == key {
                            
                            recordInfo.append((field.fieldLabel, value))
                        }
                    }
                }
                
                completion(recordInfo)
            }
            
            self.recordsNetworkService.getIndividualRecord(module: module, id: id) { [weak self] record in
                
                var recordInfo = [(String, Any)]()
                var columns = ["id"]
                
                var databaseData = [id]
                
                for field in fields {
                    
                    for (key, value) in record {
                        
                        if field.fieldLabel == key || field.apiName == key {
                            
                            let isLookup = field.lookup.module != nil
                            
                            if !key.starts(with: "$") {
                                if let recordDictionary = value as? [String: Any] {
                                    
                                    let name = recordDictionary["name"] as! String
                                    let id = recordDictionary["id"] as! String
                                    
                                    databaseData.append(id)
                                    recordInfo.append((field.fieldLabel, [id, name]))
                                    
                                } else if let value = value as? Bool {
                                    
                                    let data = value == true ? "true" : "false"
                                    
                                    databaseData.append(data)
                                    recordInfo.append((field.fieldLabel, data))
                                } else if let recordArray = value as? [String] {
                                    
                                    let data = recordArray.joined(separator: ",")
                                    
                                    databaseData.append(data)
                                    recordInfo.append((field.fieldLabel, data))
                                } else if let doubleValue = value as? Double {
                                    
                                    let data = String(doubleValue)
                                    databaseData.append(data)
                                    
                                    recordInfo.append((field.fieldLabel, data))
                                } else if let intValue = value as? Int {
                                    
                                    let data = String(intValue)
                                    databaseData.append(data)
                                    
                                    recordInfo.append((field.fieldLabel, data))
                                } else {
                                    
                                    let dateOrText = self?.convert(date: value  as? String ?? "")
                                    
                                    databaseData.append(dateOrText!)
                                    recordInfo.append((field.fieldLabel, dateOrText!))
                                }
                                
                                var column = field.apiName
                                if isLookup {
                                    
                                    column = "\(field.apiName)Id"
                                }
                                columns.append(column)
                                
                            }
                            break
                        }
                    }
                }
                
                self?.recordInfoDatabaseService
                    .createIndividualRecordTable(tableName: module, columns: columns)
                
                self?.recordInfoDatabaseService.saveIndividualRecordData(tableName: module, columns: columns, data: databaseData)
                
                completion(recordInfo)
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
        
        recordsNetworkService.deleteRecords(module: module, ids: ids) { data in
            completion(data)
        }
        
        recordsDatabaseService.deleteRecordInDatabase(module: module, ids: ids)
        
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
