//
//  NetworkManager.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 22/01/23.
//

import Foundation

class NetworkService: NetworkServiceContract {
    
    
    static let shared = NetworkService()
    private let session = URLSession.shared
//    private let session2 = URLSession(configuration: .default, delegate: , delegateQueue: <#T##OperationQueue?#>)
//    private let dispatchSemaphore = DispatchSemaphore(value: 1)
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
    
    func performDataTask(url: URL, method: String, urlComponents: URLComponents?, parameters: [String: Any?]?, headers: [String: String]?,accessToken: String?, completion: @escaping ([String: Any]?, Error?) -> Void) -> Void
    {
        
        guard let headers = headers else {
            print("No Headers Present")
            return
        }
        
        
        let requestURL = url
        var request = URLRequest(url: requestURL)
        request.httpMethod = method
//        if method ==  "GET" {
//
//            if let parameters = parameters {
//
//                reBuildURL(url: url, with: parameters) { rebuiltURL in
//                    requestURL = rebuiltURL
//                    print(requestURL.absoluteString)
//                }
//            }
//        } else {
            
        if let parameters = parameters {
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            print(String(data: request.httpBody!, encoding: .utf8)!)
        } else if let urlComponents = urlComponents {
            request.httpBody = urlComponents.query?.data(using: .utf8)
        }
//        }
        //        request.httpMethod = method
        let _ = headers.map { value, headerField in
            request.setValue(value, forHTTPHeaderField: headerField)
        }
        let task = session.dataTask(with: request) { data, response, error in
            
//            guard let response = response as? HTTPURLResponse else {
//                print("Error in response")
//                //                print(response?.url)
//                return
//            }
//
//            guard (200 ... 299).contains(response.statusCode) else {
//                print("Status Code: \(response.statusCode)")
//                return
//            }
//
//            if let error = error {
//                print("\(error) ERROR")
//                completion(nil, error)
//                return
//            }

            guard let data = data else {
                print("Error in data")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                completion(json, nil)
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }
}


