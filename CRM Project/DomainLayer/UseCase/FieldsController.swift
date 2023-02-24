//
//  FieldsController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class FieldsController {
    
    let fieldsDataManager = FieldsNetworkService()
    
    func getfields(module: String, completion: @escaping ([Field]) -> Void ) -> Void {
        
        fieldsDataManager.getfieldMetaData(module: module) { fields in
            completion(fields)
        }
    }
}
