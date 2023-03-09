//
//  UserNetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class UserNetworkService {
    
    let networkService = NetworkService()

    func getCurrentUser(completion: @escaping ([String: Any]?, Error?) -> Void) -> Void {

        let requestURLString = "crm/v3/users?type=CurrentUser"
        let method = HTTPMethod.GET

        networkService.performNetworkCall(url: requestURLString, method: method, urlComponents: nil, parameters: nil, headers: nil) { resultData, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
                return
            }
            completion(resultData, nil)
        }
        
    }
}
