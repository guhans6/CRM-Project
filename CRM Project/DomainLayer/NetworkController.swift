//
//  NetworkController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 20/01/23.
//

import Foundation


enum NetworkError: Error {
    case invalidURLError(String)
    case incorrectDataError(String)
}

enum HTTPMethod: String {
    
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
}

class NetworkController {
    
    let keyChainController = KeyChainController()
    
    deinit {
        print("Network Controller deinitialized")
    }
    
    private let networkManager = NetworkServiceManager.shared
    private let zohoURL = URL(string: "https://accounts.zoho.in/oauth/v2/token")!
    private let clientId = "1000.CCNCZ0VYDA4LNN6YCJIUBKO7WA8ZED"
    private let clientSecret = "022fb6b257cd3dff0e10460c6a7432226d46555c09"
    private let redirectURL = "https://guhans6.github.io/logIn-20611/"
    private let grantType = "authorization_code"
    
    func getAccessToken(from url: URL?) throws {
        
        print("This called")
        guard let url = url else {
            throw NetworkError.invalidURLError("Not a valid url")
        }
        
        let urlStirng = url.absoluteString
        
        guard urlStirng.contains("?code=") else{
            print("Not valid")
            return
        }
        let grantCode = try! getGrantToken(from: urlStirng) // force-unwrap here because the url should be valid
        
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "code", value: grantCode),
            URLQueryItem(name: "grant_type", value: grantType),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "redirect_uri", value: redirectURL),
        ]
        var request = URLRequest(url: zohoURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        
        //MARK: Try making all in one method for all requests
        networkManager.getAuthToken(url: zohoURL, method: HTTPMethod.POST.rawValue, components: requestBodyComponents) { data, error in

            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                let refreshToken = json["refresh_token"] as! String
                let accessToken = json["access_token"] as! String
                self.keyChainController.storeRefreshToken(token: refreshToken)
                self.keyChainController.storeAccessToken(accessToken: accessToken)
                

            } catch let jsonError {
                print("Error decoding JSON: \(jsonError)")
            }
        }
    }
    
    private func getGrantToken(from urlString: String) throws -> String {
        
        
        guard let startIndex = urlString.range(of: "code=")?.upperBound else {
            print("Not a Valid String")
            throw NetworkError.incorrectDataError("Can't get code= in string")
        }
        
        let endIndex = urlString.index(startIndex, offsetBy: 70)
        
        let grantCode = String(urlString[startIndex ..< endIndex])
        print(grantCode)
        
        return grantCode
    }
}
