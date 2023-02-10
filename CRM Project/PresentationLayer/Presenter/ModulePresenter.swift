//
//  ModulePresenter.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import Foundation


class ModulePresenter {
    
    private let networkController = NetworkController()
    private let formPresenter = FormPresenter()
    
    func getModules(completion: @escaping ([Module]) -> Void) -> Void {
        networkController.getModules { modules in
            completion(modules)
        }
    }
    
}
