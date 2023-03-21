//
//  UserDetailController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 16/02/23.
//

import Foundation


class UserDetailController: UserDetailControllerContract {

    private let userDataManager = UserDataManager()
    
    func getUserDetails(completion: @escaping (User?) -> Void) -> Void {
        
        DispatchQueue.global().async {
            
            self.userDataManager.getCurrentUserDetails { user in
                
                DispatchQueue.main.async {
                    completion(user)
                }
            }
        }
    }
}
