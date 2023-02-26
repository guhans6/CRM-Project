//
//  UseCaseContact.swift
//  CRM C
//
//  Created by guhan-pt6208 on 16/02/23.
//

import Foundation

protocol RecordsControllerContract {
    
    func addRecord(module: String, recordData: [String: Any?], isAUpdate: Bool, recordId: String?) -> Void
    
    func getRecords(module: String, id: String?, completion: @escaping ([Any]) -> Void) -> Void
    
    func deleteRecords(module: String, ids: [String], completion: @escaping ([Any]) -> Void) -> Void
}

protocol UserDetailControllerContract {
    
    func getUserDetails(completion: @escaping (User?) -> Void) -> Void
}

protocol ModulesControllerContract {
    
    func getModules(completion: @escaping ([Module]) -> Void) -> Void
}

