//
//  UserDetailController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 16/02/23.
//

import Foundation


class UserDetailController: UserDetailControllerContract {

    let userDataManager = UserNetworkService()
    

    func getUserDetails(completion: @escaping (String?) -> Void) -> Void {

        userDataManager.getUserDetails { data, error in
            completion(data)
            // MARK: HANDLE ERROR
        }
    }
}
