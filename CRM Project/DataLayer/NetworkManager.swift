//
//  NetworkManager.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 22/01/23.
//

import Foundation

class NetworkServiceManager {
    
    
    static let shared = NetworkServiceManager() // make it a singleton
    private let session = URLSession.shared
    private init() { }    
    
    func getAuthToken(url: URL, method: String, components: URLComponents, completion: @escaping (Data?, Error?) -> Void)
    {
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let response = response as? HTTPURLResponse else {
                print("Error in response")
                return
            }
            
            guard (200 ... 299).contains(response.statusCode) else {
                print("Status Code: \(response.statusCode)")
                return
            }
            
            if let error = error {
                print("\(error) ERROR")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("Error in data")
                return
            }
            
            completion(data, nil)
            
        }
        task.resume()
    }
}


