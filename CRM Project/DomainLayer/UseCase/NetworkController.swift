//
//  NetworkController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 20/01/23.
//

import Foundation

enum NetworkError: Error {          /// This is for the type of error in network
    case invalidURLError(String)
    case incorrectDataError(String)
    case invalidOauthTokenError(String)
}

enum HTTPMethod: String {
    
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PUT = "PUT"
}

class NetworkController {
    
    private let networkDataManager = NetworkDataManager()
    
    deinit {
        print("Network Controller deinitialized")
    }
    
    
    func generateAccessToken(from url: URL?) {
        
        networkDataManager.generateAccessToken(from: url)
    }
    
    func generateAuthToken() {
        
        networkDataManager.generateAuthToken()
    }
    
    func getRegistrationURL() -> String {
        
        return networkDataManager.getRegistrationURL()
    }
}
