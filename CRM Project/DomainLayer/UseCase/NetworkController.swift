//
//  NetworkController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 20/01/23.
//

import Foundation

enum HTTPMethod: String {
    
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PUT = "PUT"
}

class NetworkController : NetworkNetworkControllerContract {
    
    private let networkService = NetworkService()
    
    deinit {
        print("Network Controller deinitialized")
    }
    
    
    func generateAccessToken(from url: URL?, completion: @escaping (Bool) -> Void) -> Void {
        
        do {
            try networkService.generateAccessToken(from: url, completion: { isASuccess in
                
                DispatchQueue.main.async {
                    
                    completion(true)
                }
            })
        } catch {
            print(error)
        }
    }
    
    func generateAuthToken() -> Void {
        
        networkService.generateAuthToken { accessToken in
            
        }
    }
    
    func getRegistrationURL() -> String {
        
        return networkService.getRegistrationURL()
    }
}
