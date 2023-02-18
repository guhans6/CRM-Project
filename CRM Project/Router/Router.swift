//
//  Router.swift
//  CRM C
//
//  Created by guhan-pt6208 on 17/02/23.
//

import UIKit


class Router {
    
    let viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
}

extension Router : ModuleViewRouterContract {
    
    func navigateToRecords(module: String) {
        let recordsVc = RecordsTableViewController(module: module)
        viewController?.navigationController?.pushViewController(recordsVc, animated: true)
    }
    
}

extension Router: RecordsViewRouterContract {
    
    func addRecord(forModule: String) {
        let formViewController = FormTableViewController(module: forModule)
        viewController?.navigationController?.pushViewController(formViewController, animated: true)
    }
    
    
    // MARK: CALL ASSEMBLER
    func showRecordInfo(module: String, recordId: String) {
        
        let individualRecordVC = RecordInfoTableViewController(recordModule: module, recordId: recordId)
        let _ = UINavigationController(rootViewController: individualRecordVC)
        viewController?.navigationController?.pushViewController(individualRecordVC, animated: true)
    }
}

extension Router: LookupviewContract {
    
    func navigateToLookupRecords(module: String) {
        let lookupTableVC = LookupTableViewController(module: module)
//        lookupTableVC.delegate = cell.self
        viewController?.navigationController?.pushViewController(lookupTableVC, animated: true)
    }
}
