//
//  RecordsContract.swift
//  CRM C
//
//  Created by guhan-pt6208 on 21/03/23.
//

import Foundation

protocol AddRecordContract {
    
    func addRecord(module: String,
                   recordData: [String: Any?],
                   isAUpdate: Bool,
                   recordId: String?,
                   isRecordSaved: @escaping (Bool) -> Void) -> Void
}

protocol RecordsContract {
    
    func getAllRecordsFor(module: String, completion: @escaping ([Record]) -> Void) -> Void
    
    func sortRecords(records: [Record],
                     sortMethod: String,
                     completion: ([String: [Record]], [String]) -> Void) -> Void
}

protocol RecordInfoContract {
    
    func getIndividualRecords(module: String,
                              id: String,
                              completion: @escaping ([(String, Any)]) -> Void) -> Void
    
    func deleteRecords(module: String,
                       ids: [String],
                       completion: @escaping (Bool) -> Void) -> Void

}