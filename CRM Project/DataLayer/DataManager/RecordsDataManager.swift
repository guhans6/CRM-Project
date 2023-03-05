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
    
    func addRecord(module: String, recordData: [String: Any?], isAUpdate: Bool, recordId: String?) {
        recordsNetworkService.addRecord(module: module, recordData: recordData, isAUpdate: isAUpdate, recordId: recordId)
    }
    
    func getRecords(module: String, id: String?, completion: @escaping ([Record]) -> Void) -> Void {
        var recordsArray = [Record]()
        
        if NetworkMonitor.shared.isConnected {
            
            recordsNetworkService.getRecords(module: module, id: id) {[weak self] recordsResult in
                
                
                
                recordsResult.forEach { record in
                    
                    let secondaryData = record["Email"] as? String ?? record["Owner"] as? String ?? ""
                    
                    let recordName = record["Name"] as! String
                    let recordId = record["id"] as! String
                    recordsArray.append(Record(recordName: recordName, secondaryRecordData: secondaryData, recordId: recordId, owner: nil ,createdTime: nil, modifiedBy: nil, modifiedTime: nil ))
                }
                completion(recordsArray)
                self?.saveAllRecordsInDatabase(records: recordsArray)
            }
        } else {
            recordsNetworkService.getAllRecordsFromDataBase { [weak self] recordResult in
                
                print("Records form db")
                recordResult.forEach { record in
                    
                    print(record)
                    guard let convertedRecord = self?.convertRecord(record: record) else {
                        print("Error in converting record")
                        return
                    }
                    
                    recordsArray.append(convertedRecord)
                }
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
            completion(recordInfo)
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
            
            //            print("Valid date string")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let date = dateFormatter.date(from: date) {
//                dateFormatter.dateFormat = "dd-MM-yyyy"
//                let formattedDate = dateFormatter.string(from: date)
                
                let formattedDate = DateFormatter.formattedString(from: date, format: "dd-MM-yyyy")
                
                return formattedDate
            } else {
                // the string is invalid
                print("Invalid date string")
            }
        }
        return date
    }
    
    func saveAllRecordsInDatabase(records: [Record]) {
        
        
        let sqliteText = " TEXT"
//        let idColumn = "Module_id"
        let columns = [
            recordIdColumn.appending("\(sqliteText) PRIMARY KEY"),
            recordNameColumn.appending(sqliteText),
            secondaryDataColumn.appending(sqliteText)
            
        ]
        
        if Database.shared.createTable(tableName: tableName, columns: columns) {
            print("Records Table Created Successfully")
        } else {
            print("Failed Records")
        }
        
        for record in records {
            var recordDictionary = [String: Any]()
            
            recordDictionary[recordIdColumn] = record.recordId
            recordDictionary[recordNameColumn] = record.recordName
            recordDictionary[secondaryDataColumn] = record.secondaryRecordData
            
            if Database.shared.insert(tableName: "Records", values: recordDictionary) {
                print("Records added to db")
            } else {
                print("errr inseting records")
            }
        }
    }
}
