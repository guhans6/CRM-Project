//
//  RecordInfoDataManager.swift
//  CRM C
//
//  Created by guhan-pt6208 on 19/02/23.
//

import Foundation

class UserInfoDataManager {
    
    private let userNetworkService = UserNetworkService()
    
    func getUserDetails(completion: @escaping (String?, Error?) -> Void) -> Void {
         
        userNetworkService.getUserDetails { data, error in
            completion(data, error)
        }
    }

}
