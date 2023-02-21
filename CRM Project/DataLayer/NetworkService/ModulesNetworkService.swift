//
//  ModulesService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class ModulesNetworkService {
    
    private let networkService = NetworkService()
    
    func getModules(completion: @escaping ([Module]) -> Void) -> Void {
        
        let urlRequestString = "crm/v3/settings/modules"

        networkService.performNetworkCall(url: urlRequestString, method: .GET, urlComponents: nil, parameters: nil, headers: nil) {data in
            
            let modules = data["modules"] as! Array<Any>
            var customModules = [Module]()
            modules.forEach { module in
                
                let module = module as! [String: Any]
                if module["generated_type"] as! String == "custom" {
                    let apiName = module["api_name"] as! String
                    let moduleName = module["plural_label"] as! String

                    customModules.append(Module(apiName: apiName, moduleName: moduleName))
                }
            }
            
            completion(customModules)
        } failure: { error in
            print(error)
        }
    }
        
}
