//
//  NetworkController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 20/01/23.
//

import Foundation


enum UserType {         /// There are type to be mentioned in get users api  call
    case allUsers
    case activeUsers
    case currentuser
    case deactiveUsers
}

enum NetworkError: Error {          /// This is for the type of error in network
    case invalidURLError(String)
    case incorrectDataError(String)
}

enum HTTPMethod: String {
    
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
}

class NetworkController {
    
    private let keyChainController = KeyChainController()
    
    private let networkManager = NetworkServiceManager.shared
    private let zohoURLString = "https://accounts.zoho.in/"
    private let zohoApiURLString = "https://www.zohoapis.in/"       //MARK: URL Components
    private let tokenRequestURLString = "oauth/v2/token"
    private let redirectURL = "https://guhans6.github.io/logIn-20611/"
    private var accessToken: String {
        keyChainController.getAccessToken()
    }
    private var clientId: String {
        keyChainController.getClientId()
    }
    private var clientSecret: String {
        keyChainController.getClientSecret()
    }
    
    deinit {
        print("Network Controller deinitialized")
    }
    
    func generateAccessToken(from url: URL?) throws {
        
        let grantType = "authorization_code"
        
        guard let url = url else {
            throw NetworkError.invalidURLError("Not a valid url")
        }
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = urlComponents?.queryItems // force-unwrap here because the url should be valid
        let code = queryItems![0]
        
        guard code.name.contains("code") else {
            
            print("Code does not exists \(code)")
            return
        }
        
        
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "code", value: code.value),
            URLQueryItem(name: "grant_type", value: grantType),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "redirect_uri", value: redirectURL),
        ]
        
        let zohoURL = URL(string: zohoURLString + tokenRequestURLString)!
        
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

                UserDefaultsManager.shared.setLogIn(equalTo: true)
                print("Login Success")


            } catch let jsonError {
                print("Error decoding JSON: \(jsonError)")
            }
            print("Hmm?")
        }
    }
    
    func generateAuthToken() {
        
        let refreshToken = KeyChainController().getRefreshToken()
        
        if refreshToken == "" {
            print("invalid refresh")
            return
        }
        
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "refresh_token", value: refreshToken),
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "client_secret", value: clientSecret),
        ]
        let zohoURL = URL(string: zohoURLString + tokenRequestURLString)!
        
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
                
                let accessToken = json["access_token"] as! String
                self.keyChainController.storeAccessToken(accessToken: accessToken)
                
                print("AccessToken Generated \(accessToken)")
                
                
            } catch let jsonError {
                print("Error decoding JSON: \(jsonError)")
            }
            print("Hmm?")
        }
    }
    
    func getUserDetails(completion: @escaping (String?, Error?) -> Void) -> Void {
        
        let requestURLString = "crm/v3/users"
        let requestURL = URL(string: zohoApiURLString + requestURLString)
        
        guard let requestURL else {
            print("Not Valid")
            return
        }
        
        let parameters: [String: String] = [
            //            "type": "AllUsers"
            //            "type": "CurrentUser"
            "type": "ActiveUsers"
        ]
        let headers: [String: String] = [
            "Zoho-oauthtoken \(accessToken)": "Authorization"
        ]
        
        networkManager.performDataTask(url: requestURL, method: HTTPMethod.GET.rawValue, urlComponents: nil, parameters: parameters, headers: headers, accessToken: accessToken) { data, error in
            
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            let users = data["users"] as! [Dictionary<String, Any>]
//            print(users)
            
            DispatchQueue.main.async {
                completion((users[0]["full_name"] as! String), nil)
            }
        }
    }
    
    func getModules() -> Void {
        
        let urlRequestString = "crm/v2/settings/modules"
        let requestURL = URL(string: zohoApiURLString + urlRequestString)
        
        guard let requestURL else {
            print("Not Valid")
            return
        }
        
        let headers: [String: String] = [
            "Zoho-oauthtoken \(accessToken)": "Authorization"
        ]
        
        networkManager.performDataTask(url: requestURL, method: HTTPMethod.GET.rawValue, urlComponents: nil, parameters: nil, headers: headers, accessToken: accessToken) { data, error in
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            let modules = data
            print(modules)
        }
    }
    
    func getfieldMetaData() {
        let urlRequestString = "crm/v3/settings/fields"
        let requestURL = URL(string: zohoApiURLString + urlRequestString)
        
        guard let requestURL else {
            print("Not Valid")
            return
        }
        
        let headers: [String: String] = [
            "Zoho-oauthtoken \(accessToken)": "Authorization"
        ]
        
        let body: [String: String] = ["module": "users"]
        
        networkManager.performDataTask(url: requestURL, method: HTTPMethod.GET.rawValue, urlComponents: nil, parameters: body, headers: headers, accessToken: accessToken) { data, error in
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            let modules = data
            print(modules)
        }
    }
    
    func addEmployee() {
//        let url
    }
    
    func getProfiles() {
        let urlRequestString = "crm/v3/settings/profiles"
        let requestURL = URL(string: zohoApiURLString + urlRequestString)
        
        guard let requestURL else {
            print("Not Valid")
            return
        }
        
        let headers: [String: String] = [
            "Zoho-oauthtoken \(accessToken)": "Authorization"
        ]
        
        networkManager.performDataTask(url: requestURL, method: HTTPMethod.GET.rawValue, urlComponents: nil, parameters: nil, headers: headers, accessToken: accessToken) { data, error in
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            print(data)
        }
    }
    
    func getRoles() {
        let urlRequestString = "crm/v3/settings/roles"
        
        let requestURL = URL(string: zohoApiURLString + urlRequestString)
        
        guard let requestURL else {
            print("Not Valid")
            return
        }
        
        let headers: [String: String] = [
            "Zoho-oauthtoken \(accessToken)": "Authorization"
        ]
        
        networkManager.performDataTask(url: requestURL, method: HTTPMethod.GET.rawValue, urlComponents: nil, parameters: nil, headers: headers, accessToken: accessToken) { data, error in
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            print(data)
        }
    }
    
    private func getUserRequestType(userType: UserType) -> String {
        
        switch userType {
            
            case .activeUsers:
                return "ActiveUsers"
            case .allUsers:
                return "AllUsers"
            case .currentuser:
                return "CurrentUser"
            case .deactiveUsers:
                return "DeactiveUsers"
        }
    }
}
