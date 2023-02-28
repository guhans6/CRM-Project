//
//  Router.swift
//  CRM C
//
//  Created by guhan-pt6208 on 17/02/23.
//

import UIKit


class Router {
    
    var window: UIWindow
    weak var viewController: UIViewController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
//    init(viewController: UIViewController) {
//        self.viewController = viewController
//    }
    
    func launchApp() {
        
        let splashViewController = Assembler.getSplashView(router: self)
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
//        viewController?.present(splashViewController, animated: true)
    }

}

extension Router: SplashViewRouterContract {
    
    func showLoginView() {
        let loginView = Assembler.getLoginViewController(router: self)
        let navController = UINavigationController(rootViewController: loginView)
        navController.modalPresentationStyle = .fullScreen
        viewController?.present(loginView, animated: true)
    }
    
    func showCRMHomeView() {
        let crmHomeView = Assembler.getHomeViewController(router: self)
        viewController?.present(crmHomeView, animated: true)
    }
}

extension Router: HomeViewRouterContract {
    
    func showModules() {
        let modulesView = Assembler.getModuleTableView(router: self)
        viewController?.navigationController?.pushViewController(modulesView, animated: true)
    }
}

extension Router : ModuleViewRouterContract {
    
    func navigateToRecords(module: String) {
        let recordsVc = RecordsTableViewController(module: module, isLookup: false)
        viewController?.navigationController?.pushViewController(recordsVc, animated: true)
    }
    
}

//extension Router: RecordsViewRouterContract {
//    
//    func addRecord(forModule: String) {
//        let formViewController = FormTableViewController(module: forModule)
//        viewController?.navigationController?.pushViewController(formViewController, animated: true)
//    }
//    
//    
//    // MARK: CALL ASSEMBLER
//    func showRecordInfo(module: String, recordId: String) {
//        
//        let individualRecordVC = RecordInfoTableViewController(recordModule: module, recordId: recordId)
//        let _ = UINavigationController(rootViewController: individualRecordVC)
//        viewController?.navigationController?.pushViewController(individualRecordVC, animated: true)
//    }
//}

extension Router: LookupviewContract {
    
    func navigateToLookupRecords(module: String) {
        let lookupTableVC = LookupTableViewController(module: module, isLookup: true)
//        lookupTableVC.delegate = cell.self
        viewController?.navigationController?.pushViewController(lookupTableVC, animated: true)
    }
}
