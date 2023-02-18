//
//  PresenterContract.swift
//  CRM C
//
//  Created by guhan-pt6208 on 16/02/23.
//

import Foundation

protocol FormPresenterContract: AnyObject {
    
    func getFieldsfor(module: String, completion: @escaping ([Field]) -> Void) -> Void
    
    func showForm(fields: [Field]) -> Void
    func showLookupRecord(module: String)
    func getLayout(module: String, completion: @escaping ([Field]) -> Void) -> Void
    func saveRecord(module: String, records: [String: Any])
    func updateRecord(module: String, records: [String: Any], recordId: String?)
}


protocol FormViewContract: AnyObject {
    
    func displayFormWith(fields: [Field]) -> Void
}


