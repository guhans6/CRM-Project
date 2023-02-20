//
//  RecordsDataManager.swift
//  CRM C
//
//  Created by guhan-pt6208 on 19/02/23.
//

import Foundation

class RecordsDataManager {
    
    let recordsNetworkService = RecordsNetworkService()
    
    func addRecord(module: String, recordData: [String: Any?], isAUpdate: Bool, recordId: String?) {
        recordsNetworkService.addRecord(module: module, recordData: recordData, isAUpdate: isAUpdate, recordId: recordId)
    }
    
    func getRecords(module: String, id: String?, completion: @escaping ([Any]) -> Void) -> Void {
        recordsNetworkService.getRecords(module: module, id: id) { data in
            completion(data)
        }
    }
    
    // MARK: RETURN SUCCESS OR FAILIURE
    func deleteRecords(module: String, ids: [String], completion: @escaping ([Any]) -> Void) -> Void {
        recordsNetworkService.deleteRecords(module: module, ids: ids) { data in
            
        }
    }
}
