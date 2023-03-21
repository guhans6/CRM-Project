//
//  NetworkControllerContract.swift
//  CRM C
//
//  Created by guhan-pt6208 on 21/03/23.
//

import Foundation

protocol NetworkNetworkControllerContract {
    
    func generateAccessToken(from url: URL?) -> Void
    
    func generateAuthToken() -> Void
    
    func getRegistrationURL() -> String 
}
