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

        networkService.performNetworkCall(url: urlRequestString, method: .GET, urlComponents: nil, parameters: nil, headers: nil) { data, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            

            guard let data = data,
                  let modules = data["modules"] as? Array<Dictionary<String, Any>> else {
                print("Invalid modules data")
                return
            }

            completion(modules)
        }
    }
}
