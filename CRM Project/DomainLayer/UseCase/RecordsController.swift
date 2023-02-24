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
            completion(data)
        }
    }
    
    func deleteRecords(module: String, ids: [String], completion: @escaping ([Any]) -> Void) -> Void {
        
        recordsDataManager.deleteRecords(module: module, ids: ids) { data in
            completion(data)
        }
    }
}
