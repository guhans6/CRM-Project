//
//  Form Presenter.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 07/02/23.
//

import Foundation

enum Modules: String {
    case employees = "Employee"
    case menu = "Menu"
}

class FormPresenter {
    
    let networkController = NetworkController()
    
    func getEmployeeFields(module: Modules, completion: @escaping ([Field]) -> Void) -> Void {
        networkController.getfieldMetaData(module: module.rawValue) { fields in
            completion(fields)
        }
    }
    
    func getLayout(module: Modules, completion: @escaping ([Field]) -> Void) -> Void {
        networkController.getLayout(module: module.rawValue) { fields in
            completion(fields)
        }
    }
}
