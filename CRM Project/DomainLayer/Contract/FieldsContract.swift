//
//  FieldsContract.swift
//  CRM C
//
//  Created by guhan-pt6208 on 21/03/23.
//

import Foundation

protocol FieldsContract {
    
    func getfields(module: String, completion: @escaping ([Field]) -> Void ) -> Void
}
