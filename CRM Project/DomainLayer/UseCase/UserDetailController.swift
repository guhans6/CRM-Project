//
//  UserDetailController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 16/02/23.
//

import Foundation


class UserDetailController {

    let userDataManager = UserDataManager()
    

    func getUserDetails(completion: @escaping (String?) -> Void) -> Void {

        userDataManager.getUserDetails { data in
            completion(data)
        }
    }
}
