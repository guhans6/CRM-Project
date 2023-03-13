//
//  ModulesController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class ModulesController {
    
    private let modulesDataManager = ModulesDataManager()
    
    func getModules(completion: @escaping ([Module]) -> Void) -> Void {
        
        DispatchQueue.global().async {
            self.modulesDataManager.getModules { modules in
                
                DispatchQueue.main.async {
                    completion(modules)
                }
            }
        }
    }
}
