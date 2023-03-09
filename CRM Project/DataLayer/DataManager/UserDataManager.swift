//
//  UserDataManager.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class UserDataManager {
    
    private let userNetworkService = UserNetworkService()
    
    func getCurrentUserDetails(completion: @escaping (User) -> Void) -> Void {
        
        // Can't use weak self don't know exact reason
        let databaseService = UserDatabaseService()
        
        userNetworkService.getCurrentUser { resultData, error in
                
            guard let resultData = resultData,
                  let users = resultData["users"] as? [[String: Any]],
                  let id = users[0]["id"] as? String,
                  let fullName = users[0]["full_name"] as? String,
                  let email = users[0]["email"] as? String
            else {
                
                print("User Detail Data Error")
                return
            }
            
            let user = User(id: id,fullName: fullName, email: email)
            DispatchQueue.main.async {
                completion(user)
            }
            databaseService.saveUser(user: user)
        }
    }
}
