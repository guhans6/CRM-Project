//
//  RecordsPresenter.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import Foundation

class RecordsPresenter {
    
    let networkController = NetworkController()
    
    func displayRecords(for module: String, completion: @escaping ([Record]) -> Void) -> Void {
        networkController.getRecords(module: module) { records in
            
            var recordArray = [Record]()
            
            records.forEach { record in
                
                let record = record as! [String: Any]
                var secondaryData = ""
                
                if module == "Employee" {
                    secondaryData = record["Email"] as! String
                }
                let recordName = record["Name"] as! String
                let recordId = record["id"] as! String
                recordArray.append(Record(recordName: recordName, secondaryRecordData: secondaryData, recordId: recordId))
            }
            
            completion(recordArray)
        }
    }
    
    func deleteRecords(for module: String, ids: [String]) {
        
    }
}
