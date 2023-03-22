//
//  FieldsController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class FieldsController: FieldsContract {
    
    private let fieldsDataManager = FieldsDataManager()
    
    func getfields(module: String, completion: @escaping ([Field]) -> Void ) -> Void {
        
        DispatchQueue.global().async {
            self.fieldsDataManager.getfieldMetaData(module: module) { fields in
                DispatchQueue.main.async {
                    completion(fields)
                }
            }
        }
    }
}
