//
//  ModuleViewContract.swift
//  CRM C
//
//  Created by guhan-pt6208 on 17/02/23.
//

import Foundation

protocol ModuleViewContract: AnyObject {
    
    func showModules(modules: [Module]) -> Void
}

protocol ModulesPresenterContract: AnyObject {
    
    func getModules(completion: @escaping ([Module]) -> Void) -> Void
    func displayModules(modules: [Module]) -> Void
    func showRecords(for module: String) -> Void
}

protocol ModuleViewRouterContract: AnyObject {
    
    func navigateToRecords(module: String)
}
