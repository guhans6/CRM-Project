//
//  UserDataManager.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class UserDataManager {
    
    private let userNetworkService = UserNetworkService()
    private let databaseService = UserDatabaseService()
    
    func getCurrentUserDetails(completion: @escaping (User) -> Void) -> Void {
        
        databaseService.getUser { user in
                
            completion(user)
        }
        
        self.getUserFromNetwork { user in
            completion(user)
        }
    }
    
    func getUserFromNetwork(completion: @escaping (User) -> Void) -> Void {
        
        userNetworkService.getCurrentUser { [weak self] resultData, error in
            
            guard let resultData = resultData,
                  let users = resultData["users"] as? [[String: Any]],
                  let id = users[0]["id"] as? String,
                  let fullName = users[0]["full_name"] as? String,
                  let email = users[0]["email"] as? String,
                  let firstName = users[0]["first_name"] as? String
            else {
                
                print("User Detail Data Error")
                return
            }
            
            let user = User(id: id,fullName: fullName, email: email, firstName: firstName)
            completion(user)
            self?.databaseService.saveUser(user: user)
        }
    }
}
