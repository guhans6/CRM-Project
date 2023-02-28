//
//  RecordsPresenter.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import Foundation

class RecordsPresenter {
    
    private let recordsController = RecordsController()
    private weak var recordViewController: RecordsViewContract?
    private weak var router: Router?
    
//    init(recordViewController: RecordsTableViewController? = nil) {
//        self.recordViewController = recordViewController
//    }
    
}

extension RecordsPresenter: RecordsPresenterContract {
    
    func getAllRecordsFor(module: String, completion: @escaping ([Record]) -> Void) -> Void {
        
        recordsController.getAllRecordsFor(module: module) { records in
            
            completion(records)
        }
    }
    
    func showAllRecords(records: [Record]) {
        recordViewController?.displayRecords(records: records)
    }
    
    func deleteRecords(for module: String, ids: [String]) {
        recordsController.deleteRecords(module: module, ids: ids) { result in
            
        }
    }
    
//    func showRecord(for module: String, recordId: String) {
//        router?.showRecordInfo(module: module, recordId: recordId)
//    }
    
}
