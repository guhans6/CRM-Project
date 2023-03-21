//
//  UserDetailControllerContract.swift
//  CRM C
//
//  Created by guhan-pt6208 on 21/03/23.
//

import Foundation

protocol UserDetailControllerContract {
    
    func getUserDetails(completion: @escaping (User?) -> Void) -> Void
}
