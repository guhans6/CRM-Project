//
//  FieldsNetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class FieldsNetworkService {
    
    let networkService = NetworkService()
    
    // MARK: USE JSON DECODING
    func getfieldMetaData(module: String, completion: @escaping ([String: Any]) -> Void ) -> Void {
        
        let urlRequestString = "crm/v3/settings/fields?module=\(module)"
        
        networkService.performNetworkCall(url: urlRequestString, method: .GET, urlComponents: nil, parameters: nil, headers: nil) { data, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("Fields is nil")
                return
            }
            completion(data)
            
        }
    }
}
