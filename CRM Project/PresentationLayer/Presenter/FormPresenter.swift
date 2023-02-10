//
//  Form Presenter.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 07/02/23.
//

import Foundation

enum ModuleType: String {
    case employees = "Employee"
    case menu = "Menu"
    case employeeRole = "EmployeeRoles"
}

class FormPresenter {
    
    let networkController = NetworkController()
    
    func getEmployeeFields(module: ModuleType, completion: @escaping ([Field]) -> Void) -> Void {
        networkController.getfieldMetaData(module: module.rawValue) { fields in
            completion(fields)
        }
    }
    
    func getLayout(module: String, completion: @escaping ([Field]) -> Void) -> Void {
        networkController.getLayout(module: module) { fields in
            completion(fields)
        }
    }
    
    func saveRecord(module: String, record: [String: Any]) {
        networkController.addRecord(module: module, data: record)
    }
}
