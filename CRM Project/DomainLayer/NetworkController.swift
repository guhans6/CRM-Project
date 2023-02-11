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
    case invalidOauthTokenError(String)
}

enum HTTPMethod: String {
    
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
}

class NetworkController {
    
    private let keyChainController = KeyChainController()
    private let userDefaults = UserDefaultsManager.shared
    
    private let networkManager = NetworkServiceManager.shared
    private let zohoURLString = "https://accounts.zoho.com/"
    private let zohoApiURLString = "https://www.zohoapis.com/"       //MARK: URL Components
    private let tokenRequestURLString = "oauth/v2/token"
    private let redirectURL = "https://guhans6.github.io/logIn-20611/"
    private let crmV3 = "crm/v3"
    private var accessToken: String {
        get {
            getAccessToken()
        }
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
        
//        let headers = ["application/x-www-form-urlencoded": "Content-Type"]
        
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
                print(json)


            } catch let jsonError {
                print("Error decoding JSON: \(jsonError)")
            }
        }
    }
    
    func generateAuthToken() {
        
        let refreshToken = keyChainController.getRefreshToken()
        
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
                self.userDefaults.saveTokenGeneratedTime()
                
                print("AccessToken Generated \(accessToken)")
                
                
            } catch let jsonError {
                print("Error decoding JSON: \(jsonError)")
            }
        }
    }
    
    func getUserDetails(completion: @escaping (String?, Error?) -> Void) -> Void {
        
        let requestURLString = "crm/v3/users"
        let requestURL = URL(string: zohoApiURLString + requestURLString)
        
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
    
    func getModules(completion: @escaping ([Module]) -> Void) -> Void {
        
        let urlRequestString = "crm/v3/settings/modules"
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
            
            let modules = data["modules"] as! Array<Any>
            var customModules = [Module]()
            modules.forEach { module in
                let module = module as! [String: Any]
                if module["generated_type"] as! String == "custom" {
                    let apiName = module["api_name"] as! String
                    let moduleName = module["plural_label"] as! String
                    
                    customModules.append(Module(apiName: apiName, moduleName: moduleName))
                }
            }
            DispatchQueue.main.async {
                completion(customModules)                
            }
        }
    }
    
    func getfieldMetaData(module: String, completion: @escaping ([Field]) -> Void ) -> Void {
        
        let urlRequestString = "crm/v3/settings/fields?module=\(module)"
        let requestURL = URL(string: zohoApiURLString + urlRequestString)
        var returnData = [Field]()
        
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
            
            let fields = data["fields"] as! Array<Any>
            
            for field in fields {
                
                let field = field as! [String: Any]
                let jsonType = field["json_type"] as! String
                let displayLabel = field["field_label"] as! String
                let fieldApiName = field["api_name"] as! String
                returnData.append(Field(fieldName: displayLabel, fieldType: jsonType, fieldApiName: fieldApiName))
            }
            DispatchQueue.main.async {
//                print(1)
                completion(returnData)
            }
        }
    }
    
    func getLayout(module: String, completion: @escaping ([Field]) -> Void ) -> Void {
        let urlRequestString = "crm/v3/settings/layouts?module=\(module)"
        let requestURL = URL(string: zohoApiURLString + urlRequestString)
        var returnData = [Field]()
        
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
            
            let layouts = data["layouts"] as! Array<Any>
            
            let layout = layouts[0] as! [String: Any]
            let sections = layout["sections"] as! Array<Any>
            
            for i in 0..<sections.count {
                let fields = sections[i] as! [String: Any]
                let field = fields["fields"] as! Array<Any>
                
                for j in 0..<field.count {
                    
                    let type = field[j] as! [String: Any]
                    let jsonType = type["json_type"] as! String
                    let displayLabel = type["field_label"] as! String
                    let fieldApiName = type["api_name"] as! String
                    returnData.append(Field(fieldName: displayLabel, fieldType: jsonType, fieldApiName: fieldApiName))
                }
            }
            DispatchQueue.main.async {
                completion(returnData)
            }
        }
    }
    
    func addRecord(module: String, data: [String: Any?]) {
        
        let urlRequestString = "crm/v3/\(module)"
        let requestURL = URL(string: zohoApiURLString + urlRequestString)
        
        guard let requestURL else {
            print("Not Valid")
            return
        }
        
        let headers: [String: String] = [
            "Zoho-oauthtoken \(accessToken)": "Authorization"
        ]
        
        
        let newData = data.filter {
            return $0.value as! String == "" ? false : true
        }
        
        let parameter = ["data": [newData]]


        networkManager.performDataTask(url: requestURL, method: HTTPMethod.POST.rawValue, urlComponents: nil, parameters: parameter, headers: headers, accessToken: accessToken) { data, error in

            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let result = data else {
                print("No data received")
                return
            }

            print(result)

        }
    }
    
    func getRecords(module: String, completion: @escaping ([Any]) -> Void) ->Void {
        let urlRequestString = "crm/v3/\(module)?fields=Name,Email"
        
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
            
            let recordsResult = data["data"] as! [Any]

            DispatchQueue.main.async {
                completion(recordsResult)
            }
        }
    }
    
    func fromMailAddress() {
        let urlRequestString = "crm/v3/settings/emails/actions/from_addresses"
        
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
    
    private func getAccessToken() -> String {
        
        let lastGeneratedTime = userDefaults.getLastTokenGenereatedTime()

        if Date().timeIntervalSinceReferenceDate - lastGeneratedTime.timeIntervalSinceReferenceDate >= 3480 {
            self.generateAuthToken()

        }
        return keyChainController.getAccessToken()
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
