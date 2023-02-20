//
//  FieldsDataManager.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class FieldsDataManager {
    
    let fieldNetworkService = FieldsNetworkService()
    
    func getfieldMetaData(module: String, completion: @escaping ([Field]) -> Void ) -> Void {
        
        fieldNetworkService.getfieldMetaData(module: module) { data in
            completion(data)
        }
    }
}
