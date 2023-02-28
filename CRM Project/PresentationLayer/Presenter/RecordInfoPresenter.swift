//
//  IndividualRecordPresenter.swift
//  CRM C
//
//  Created by guhan-pt6208 on 14/02/23.
//

import Foundation

class RecordInfoPresenter {
    
    private let recordsController = RecordsController()
    private weak var recordInfoVc: RecordInfoViewContract?
    
    init(recordInfoVc: RecordInfoViewContract? = nil) {
        self.recordInfoVc = recordInfoVc
    }
    
}

extension RecordInfoPresenter: RecordInfoPresenterContract {
    
    func getRecordFor(id: String, module: String, completion: @escaping ([(String, Any)]) -> Void ) -> Void {
        recordsController.getRecords(module: module, id: id) { recordForId in
            
            completion(recordForId)
        }
    }
    
    func displayRecordInfo(record: [(String, String)]) {
        recordInfoVc?.displayRecordInfo(of: record)
    }
    
}
