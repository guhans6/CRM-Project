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
    
    func getRecordFor(id: String, module: String, completion: @escaping ([(String, String)]) -> Void ) -> Void {
        recordsController.getRecords(module: module, id: id) { recordForId in
            
            let record = recordForId[0] as! [String: Any]
            
            
            
            var recordInfo = [(String, String)]()
            let name = "Name"
            let owner = "Owner"         // This should be in usecase layer
            
            record.forEach { key, value in
                if !key.starts(with: "$") {
                    if let recordDictionary = value as? [String: Any] {
                        
                        let name = recordDictionary["name"] as! String
                        recordInfo.append((key, name))
                    }
//                    else if key == name || key == owner {
//
//                        recordInfo.append(("\(module) \(key)", value as! String))
//                    }
                    else if let value = value as? Bool {
                        
                        recordInfo.append((key, value == true ? "true" : "false"))
                    } else if let recordArray = value as? [String] {
                        
                        recordInfo.append((key, recordArray.joined(separator: ",")))
                    } else if let doubleValue = value as? Double {
                        
                        recordInfo.append((key, String(doubleValue)))
                    } else if let intValue = value as? Int {
                        
                        recordInfo.append((key, String(intValue)))
                    } else {
                        recordInfo.append((key, value as? String ?? ""))
                    }
//                    recordInfo.append((key, editedInfo))
                }
            }
            completion(recordInfo)
//            self.displayRecordInfo(record: recordInfo)
        }
    }
    
    func displayRecordInfo(record: [(String, String)]) {
        recordInfoVc?.displayRecordInfo(of: record)
    }
    
}
