//
//  ModulePresenter.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import Foundation


class ModulesPresenter {
    
    private let networkController: NetworkControllerContract = NetworkController()
    private let formPresenter = FormPresenter()
    private weak var router: Router?
    private weak var moduleTableView: ModuleViewContract?
    
   
//    init(networkController: NetworkControllerContract) {
//        self.networkController = networkController
//    }
}

extension ModulesPresenter: ModulesPresenterContract {
    
    func showRecords(for module: String) {
        router?.navigateToRecords(module: module)
    }
    
    func getModules(completion: @escaping ([Module]) -> Void) -> Void {
        networkController.getModules { modules in
            completion(modules)
            
//            self.displayModules(modules: modules)
        }
    }
    
    func displayModules(modules: [Module]) {
        
        moduleTableView?.showModules(modules: modules)
    }
}
