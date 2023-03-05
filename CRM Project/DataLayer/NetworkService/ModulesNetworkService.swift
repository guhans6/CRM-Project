//
//  ModulesService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class ModulesNetworkService {
    
    private let networkService = NetworkService()
    
    private let tableName = "Modules"
    
    func getModules(completion: @escaping ([[String: Any]]) -> Void) -> Void {
        
        let urlRequestString = "crm/v3/settings/modules"

        networkService.performNetworkCall(url: urlRequestString, method: .GET, urlComponents: nil, parameters: nil, headers: nil) { data in
            
            
            
//            let modules = data["modules"] as! Array<Any>
//
            let modules = data["modules"] as! Array<Dictionary<String, Any>>

            completion(modules)
        } failure: { error in
            print(error)
        }
    }
        
    
    func getAllModulesFromDataBase(completion: @escaping ([[String: Any]]) -> Void ) {
        
        let result = Database.shared.select(tableName: tableName)
        
//        print(result?.count)
        if let result = result {
            completion(result)
        } else {
            print("result is nil")
        }
    }

}
