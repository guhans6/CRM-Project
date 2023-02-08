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
    
    func performDataTask(url: URL, method: String, urlComponents: URLComponents?, parameters: [String: Any]?, headers: [String: String]?,accessToken: String, completion: @escaping ([String: Any]?, Error?) -> Void) -> Void
    {
        
        guard let headers = headers else {
            print("No Headers Present")
            return
        }
        
        var requestURL = url
        var request = URLRequest(url: requestURL)
        request.httpMethod = method
        if method ==  "GET" {
            
            if let parameters = parameters {
                
                reBuildURL(url: url, with: parameters) { rebuiltURL in
                    requestURL = rebuiltURL
                    print(requestURL.absoluteString)
                }
            }
        } else {
            
            if let parameters = parameters {
                
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } else if let urlComponents = urlComponents {
                request.httpBody = urlComponents.query?.data(using: .utf8)
            }
        }
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
//
            guard let data = data else {
                print("Error in data")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                print(json)
                completion(json, nil)
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }
    
    //    func performGetRequest(url: URL, method: String, parameters: [String: Any]?,headers: [String: String]?,accessToken: String, completion: @escaping (Data?, Error?) -> Void) -> Void {
    //
    //    }
    
    func reBuildURL(url: URL, with parameters: [String: Any]?, completion: (URL) -> Void) -> Void {
        let urlString = url.absoluteString
        
        var paramString = "?"
        guard let parameters = parameters as? [String: String] else {
            print("Invalid parameters while building url")
            //            completion("")
            return
        }
        let _ = parameters.map {
            paramString += "\($0)=\($1)&"
        }
        
        guard let rebuiltURL = URL(string: urlString + paramString) else {
            return
        }
        completion(rebuiltURL)
    }
}


