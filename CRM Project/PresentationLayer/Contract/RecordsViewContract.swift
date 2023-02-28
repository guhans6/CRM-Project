//
//  RecordsViewContract.swift
//  CRM C
//
//  Created by guhan-pt6208 on 17/02/23.
//

import Foundation

protocol RecordsViewContract: AnyObject {
    
    func displayRecords(records: [Record]) -> Void
}

protocol RecordsPresenterContract: AnyObject {
    
    func getAllRecordsFor(module: String, completion: @escaping ([Record]) -> Void) -> Void
    func showAllRecords(records: [Record]) -> Void
    func deleteRecords(for module: String, ids: [String]) -> Void
//    func showRecord(for module: String, recordId: String) -> Void
}

protocol RecordsViewRouterContract: AnyObject {
    
    func addRecord(forModule: String) -> Void
    func showRecordInfo(module: String, recordId: String) -> Void
}
