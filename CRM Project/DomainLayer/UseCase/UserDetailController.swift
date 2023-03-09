//
//  UserDetailController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 16/02/23.
//

import Foundation


class UserDetailController: UserDetailControllerContract {

    let userDataManager = UserDataManager()
    

    func getUserDetails(completion: @escaping (User?) -> Void) -> Void {
        
        userDataManager.getCurrentUserDetails { user in
            completion(user)
        }
    }
}
