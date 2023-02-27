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
    
    func getRecords(module: String, id: String?, completion: @escaping ([Any]) -> Void) -> Void {
        
        recordsDataManager.getRecords(module: module, id: id) { data in
            
//            var records = [Record]()
//
//            data.forEach { record in
//
//                let record = record as! [String: Any]
//                var secondaryData = ""
//
//                if module == "Employee" {
//                    secondaryData = record["Email"] as? String ?? ""
//                }
//                let recordName = record["Name"] as! String
//                let recordId = record["id"] as! String
//                records.append(Record(recordName: recordName, secondaryRecordData: secondaryData, recordId: recordId, owner: nil ,createdTime: nil, modifiedBy: nil, modifiedTime: nil))
//            }
            
            completion(data)
        }
    }
    
    func deleteRecords(module: String, ids: [String], completion: @escaping ([Any]) -> Void) -> Void {
        
        recordsDataManager.deleteRecords(module: module, ids: ids) { data in
            completion(data)
        }
    }
}
