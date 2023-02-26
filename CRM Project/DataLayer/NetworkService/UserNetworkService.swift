//
//  UserNetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class UserNetworkService {
    
    let networkService = NetworkService()

    func getUserDetails(completion: @escaping (User, Error?) -> Void) -> Void {

        let requestURLString = "crm/v3/users?type=CurrentUser"
        let method = HTTPMethod.GET

        networkService.performNetworkCall(url: requestURLString, method: method, urlComponents: nil, parameters: nil, headers: nil) { resultData in

            let users = resultData["users"] as! [[String: Any]]
            let fullName = users[0]["full_name"] as! String
            let email = users[0]["email"] as! String
            
            completion(User(fullName: fullName, email: email), nil)
        } failure: { error in
            print(error)
        }
        
    }
}
