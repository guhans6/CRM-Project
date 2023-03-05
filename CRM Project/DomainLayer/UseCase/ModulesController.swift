//
//  ModulesController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class ModulesController: ModulesControllerContract {
    
    let moduleNetworkService = ModulesNetworkService()
    let modulesDataManager = ModulesDataManager()
    
    func getModules(completion: @escaping ([Module]) -> Void) -> Void {
//        moduleNetworkService.getModules { data in
//            completion(data)
//        }
        
        modulesDataManager.getModules { modules in
            completion(modules)
        }
    }
}
