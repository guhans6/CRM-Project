//
//  RecordsPresenter.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import Foundation

class RecordsPresenter {
    
    private let networkController = NetworkController()
    private weak var recordViewController: RecordsViewContract?
    private weak var router: Router?
    
//    init(recordViewController: RecordsTableViewController? = nil) {
//        self.recordViewController = recordViewController
//    }
    
}

extension RecordsPresenter: RecordsPresenterContract {
    
    func getAllRecordsFor(module: String, completion: @escaping ([Record]) -> Void) -> Void {
        RecordsController().getRecords(module: module, id: nil) { [weak self] records in
            
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
//            print("working")
//            self?.showAllRecords(records: recordArray)
        }
    }
    
    func showAllRecords(records: [Record]) {
        recordViewController?.displayRecords(records: records)
    }
    
    func deleteRecords(for module: String, ids: [String]) {
        networkController.deleteRecords(module: module, ids: ids) { result in
            
        }
    }
    
    func showRecord(for module: String, recordId: String) {
        router?.showRecordInfo(module: module, recordId: recordId)
    }
    
}
