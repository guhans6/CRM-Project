//
//  IndividualRecordPresenter.swift
//  CRM C
//
//  Created by guhan-pt6208 on 14/02/23.
//

import Foundation

class RecordInfoPresenter {
    
    let networkController = NetworkController()
    
    func getRecordFor(id: String, module: String, completion: @escaping ([(String, Any)]) -> Void ) -> Void {
        networkController.getRecords(module: module, id: id) { recordForId in
            
            let record = recordForId[0] as! [String: Any]
            
            
            
            var recordInfo = [(String, Any)]()
            let name = "Name"
            let owner = "Owner"         // This should be in usecase layer
            
            record.forEach { key, value in
                if !key.starts(with: "$") {
                    if let recordDictionary = value as? [String: Any] {
                        recordInfo.append((key, recordDictionary["name"] as! String))
                    } else if key == name || key == owner {
                        let editedInfo = "Employee \(key)"
                        recordInfo.append((editedInfo, value))
                    } else {
                        recordInfo.append((key, value))
                    }
                }
            }
//
            completion(recordInfo)
        }
    }
}
