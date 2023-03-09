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
    
    let recordsNetworkService = RecordsNetworkService()
    
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
                    id: String?,
                    completion: @escaping ([Record]) -> Void) -> Void {
        
        let databaseService = RecordsDatabaseService()
        
        databaseService.getAllRecordsFromDataBase(module: module) { [weak self] recordResult in
            
            var recordsArray = [Record]()
            print("Records form db")
            recordResult.forEach { record in
                
                print(record)
                guard let convertedRecord = self?.convertRecord(record: record) else {
                    print("Error in converting record")
                    return
                }
                
                recordsArray.append(convertedRecord)
            }
            
            DispatchQueue.main.async {
                completion(recordsArray)
            }
        }
        
        recordsNetworkService.getRecords(module: module, id: id) { recordsResult, error in
            
            var recordsArray = [Record]()
            
            if let error = error {
                
                if let networkError = error as? NetworkError, networkError == .emptyDataError {
                    
                    DispatchQueue.main.async {
                        completion(recordsArray)
                    }
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
                
                recordsArray.append(Record(recordName: recordName, secondaryRecordData: secondaryData, recordId: recordId, owner: nil ,createdTime: nil, modifiedBy: nil, modifiedTime: nil ))
            }
            
            databaseService.saveAllRecordsInDatabase(records: recordsArray, moduleApiName: module)
            
            DispatchQueue.main.async {
                completion(recordsArray)
            }
            
        }
    }
    
    private func convertRecord(record: [String: Any]) -> Record {
        
        let recordId = record[recordIdColumn] as! String
        let recordName = record[recordNameColumn] as! String
        let secodaryData = record[secondaryDataColumn] as! String
        
        return Record(recordName: recordName, secondaryRecordData: secodaryData, recordId: recordId, owner: nil, createdTime: nil, modifiedBy: nil, modifiedTime: nil)
    }
    
    func getRecordById(module: String,
                       id: String?,
                       completion: @escaping ([(String, Any)]) -> Void) -> Void {
        
        recordsNetworkService.getIndividualRecord(module: module, id: id) { record in
            
            
            var recordInfo = [(String, Any)]()
            // This should be in usecase layer
            
            record.forEach { key, value in
                
                if !key.starts(with: "$") {
                    if let recordDictionary = value as? [String: Any] {
                        
                        let name = recordDictionary["name"] as! String
                        let id = recordDictionary["id"] as! String
                        
                        recordInfo.append((key, [id, name]))
                        
                    } else if let value = value as? Bool {
                        
                        recordInfo.append((key, value == true ? "true" : "false"))
                    } else if let recordArray = value as? [String] {
                        
                        recordInfo.append((key, recordArray.joined(separator: ",")))
                    } else if let doubleValue = value as? Double {
                        
                        recordInfo.append((key, doubleValue))
                    } else if let intValue = value as? Int {
                        
                        recordInfo.append((key, String(intValue)))
                    } else {
                        
                        let date = self.convert(date: value  as? String ?? "")
                        
                        recordInfo.append((key, date))
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion(recordInfo)
            }
        }
        
    }
    
    // MARK: RETURN SUCCESS OR FAILIURE
    func deleteRecords(module: String, ids: [String], completion: @escaping ([Any]) -> Void) -> Void {
        recordsNetworkService.deleteRecords(module: module, ids: ids) { data in
            
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
