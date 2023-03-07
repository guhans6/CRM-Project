//
//  DataManagerContract.swift
//  CRM C
//
//  Created by guhan-pt6208 on 19/02/23.
//

import Foundation

protocol NetworkManager {
    
    func saveGrantToken()
}

protocol DatabaseServiceContract {
    
}

protocol NetworkContract {
    
    func getAuthToken(url: URL, method: String, components: URLComponents, completion: @escaping (Data?, Error?) -> Void) -> Void
    
    func performDataTask(url: URL, method: String, urlComponents: URLComponents?, parameters: [String: Any?]?, headers: [String: String]?, success: @escaping ([String: Any]?, Error?) -> Void) -> Void
}

