//
//  RecordsController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 16/02/23.
//

import Foundation

class RecordsController: RecordsControllerContract {
    
    let recordsDataManager = RecordsNetworkService()
    
    func addRecord(module: String, recordData: [String: Any?], isAUpdate: Bool, recordId: String?) {
        
        recordsDataManager.addRecord(module: module, recordData: recordData, isAUpdate: isAUpdate, recordId: recordId)
    }
    
    func getAllRecordsFor(module: String, completion: @escaping ([Record]) -> Void) -> Void {
        
        recordsDataManager.getRecords(module: module, id: nil) { data in
            
            var recordArray = [Record]()
            data.forEach { record in
                
                let record = record as! [String: Any]
                var secondaryData = ""
                
                if module == "Employee" {
                    secondaryData = record["Email"] as? String ?? ""
                }
                let recordName = record["Name"] as! String
                let recordId = record["id"] as! String
                recordArray.append(Record(recordName: recordName, secondaryRecordData: secondaryData, recordId: recordId, owner: nil ,createdTime: nil, modifiedBy: nil, modifiedTime: nil ))
            }
            
            completion(recordArray)
        }
    }
    
    func getRecords(module: String, id: String?, completion: @escaping ([(String, String)]) -> Void) -> Void {
        
        recordsDataManager.getRecords(module: module, id: id) { data in
            
             let record = data[0] as! [String: Any]
            
            
            var recordInfo = [(String, String)]()
             // This should be in usecase layer
            
            record.forEach { key, value in
                
                if !key.starts(with: "$") {
                    if let recordDictionary = value as? [String: Any] {
                        
                        let name = recordDictionary["name"] as! String
                        recordInfo.append((key, name))
                    }
//                    else if key == name || key == owner {
//
//                        recordInfo.append(("\(module) \(key)", value as! String))
//                    }
                    else if let value = value as? Bool {
                        
                        recordInfo.append((key, value == true ? "true" : "false"))
                    } else if let recordArray = value as? [String] {
                        
                        recordInfo.append((key, recordArray.joined(separator: ",")))
                    } else if let doubleValue = value as? Double {
                        
                        recordInfo.append((key, String(doubleValue)))
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
    
    private func convert(date: String) -> String {
        
        
        
        let regex = #"^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2]\d|3[0-1])$"# // your regex pattern

        if let _ = date.range(of: regex, options: .regularExpression) {
    
//            print("Valid date string")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let date = dateFormatter.date(from: date) {
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let formattedDate = dateFormatter.string(from: date)
                
                return formattedDate
            } else {
                // the string is invalid
                print("Invalid date string")
            }
        }
        return date
    }
    
    func deleteRecords(module: String, ids: [String], completion: @escaping ([Any]) -> Void) -> Void {
        
        recordsDataManager.deleteRecords(module: module, ids: ids) { data in
            completion(data)
        }
    }
}
