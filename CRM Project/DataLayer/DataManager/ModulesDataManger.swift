//
//  ModulesDataManger.swift
//  CRM C
//
//  Created by guhan-pt6208 on 19/02/23.
//

import Foundation

class ModulesDataManager {
    
    let networkService = ModulesNetworkService()
    
    func getModules(modules: @escaping ([Module]) -> Void) -> Void {
        
        networkService.getModules(completion: modules)
    }
}
