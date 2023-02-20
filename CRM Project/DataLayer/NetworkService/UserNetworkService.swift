//
//  UserNetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class UserNetworkService {
    
    let networkService = NetworkService()

    func getUserDetails(completion: @escaping (String?, Error?) -> Void) -> Void {

        let requestURLString = "crm/v3/users"
        let method = HTTPMethod.GET

        networkService.performNetworkCall(url: requestURLString, method: method, urlComponents: nil, parameters: nil, headers: nil) { resultData in

            let users = resultData["users"] as! [[String: Any]]
            print(users)
            
            DispatchQueue.main.async {
                completion((users[0]["full_name"] as! String), nil)
            } 
        } failure: { error in
            print(error)
        }
        
    }
}
