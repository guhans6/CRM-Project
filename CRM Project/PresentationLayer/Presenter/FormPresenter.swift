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
    
    private let recordsController = RecordsController()
    private let fieldsContorller = FieldsController()
    private weak var formViewController: FormViewContract?
    private weak var router: Router?
    
}

extension FormPresenter: FormPresenterContract {
    
    func getFieldsfor(module: String, completion: @escaping ([Field]) -> Void) -> Void {
        fieldsContorller.getfields(module: module) { [weak self] fields in
            completion(fields)
//            self?.showForm(fields: fields)
        }
    }
    
    func showForm(fields: [Field]) {
        formViewController?.displayFormWith(fields: fields)
    }
    
    func getLayout(module: String, completion: @escaping ([Fiel]) -> Void) -> Void {
//        networkController.getLayout(module: module) { fields in
//            completion(fields)
//        }
    }
    
    func saveRecord(module: String, records: [String: Any]) {
        recordsController.addRecord(module: module, recordData: records, isAUpdate: false, recordId: nil)
    }
    
    func updateRecord(module: String, records: [String: Any], recordId: String?) {
        recordsController.addRecord(module: module, recordData: records, isAUpdate: true, recordId: recordId)
    }
    
    func showLookupRecord(module: String) {
        
    }
}
