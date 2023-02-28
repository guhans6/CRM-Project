//
//  RecordInfoViewContract.swift
//  CRM C
//
//  Created by guhan-pt6208 on 17/02/23.
//

import Foundation

protocol RecordInfoViewContract: AnyObject {
    
    func displayRecordInfo(of record: [(String, String)]) -> Void
}

protocol RecordInfoPresenterContract: AnyObject {
    
    func getRecordFor(id: String, module: String, completion: @escaping ([(String, Any)]) -> Void ) -> Void
    func displayRecordInfo(record: [(String, String)]) -> Void
}

protocol RecordInfoRouterContract: AnyObject {
    
    func editRecord(module: String, recordId: String, recordInfo: [String: String]) -> Void
}

