//
//  DataManager.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 20/01/23.
//

import Foundation


protocol NetworkManager {
    
    func saveGrantToken()
}

protocol DatabaseManager {
    
}

protocol NetworkServiceContract {
    
    func getAuthToken(url: URL, method: String, components: URLComponents, completion: @escaping (Data?, Error?) -> Void) -> Void
    
    func performDataTask(url: URL, method: String, urlComponents: URLComponents?, parameters: [String: Any?]?, headers: [String: String]?,accessToken: String?, completion: @escaping ([String: Any]?, Error?) -> Void) -> Void
}
