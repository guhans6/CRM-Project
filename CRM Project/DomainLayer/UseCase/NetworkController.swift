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

class NetworkController: NetworkControllerContract {
    
    private let keyChainController = KeyChainController()
    private let userDefaults = UserDefaultsManager.shared
    private let networkService: NetworkServiceContract = NetworkService.shared
    
    private let zohoURLString = "https://accounts.zoho.com/"
    private let zohoApiURLString = "https://www.zohoapis.com/"       //MARK: URL Components
    private let tokenRequestURLString = "oauth/v2/token"
    private let redirectURL = "https://guhans6.github.io/logIn-20611/"
    private let crmV3 = "crm/v3"
    private var token = ""
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
        networkService.getAuthToken(url: zohoURL, method: HTTPMethod.POST.rawValue, components: requestBodyComponents) { data, error in

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
                self.token = accessToken

                UserDefaultsManager.shared.setLogIn(equalTo: true)
                print("Login Success")

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
        
        networkService.getAuthToken(url: zohoURL, method: HTTPMethod.POST.rawValue, components: requestBodyComponents) { data, error in
            
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
                self.token = accessToken
                print("AccessToken Generated \(accessToken)")
                
                
            } catch let jsonError {
                print("Error decoding JSON: \(jsonError)")
            }
        }
    }
    
    func performNetworkCall(url: String, method: HTTPMethod, urlComponents: [String: String]?, parameters: [String: Any]?, headers: [String: String]?, completion: @escaping ([String: Any]) -> Void) -> Void {
        
        var authHeader: [String: String] = ["Zoho-oauthtoken \(accessToken)": "Authorization"]
        let requestURLString = zohoApiURLString.appending(url)
        let requestURL = URL(string: requestURLString)
        
        guard let requestURL = requestURL else {
            print("Invalid URL")
            return
        }
        
        var requestBodyComponents: URLComponents? = nil
        
        if let urlComponents = urlComponents {
            
            requestBodyComponents = URLComponents()
            urlComponents.forEach { key, value in
                let queryItem = URLQueryItem(name: key, value: value)
                
                requestBodyComponents?.queryItems?.append(queryItem)
            }
        }
        
        if let headers = headers {
            headers.forEach { key, value in
                authHeader[key] = value
            }
        }
        
        networkService.performDataTask(url: requestURL, method: method.rawValue, urlComponents: requestBodyComponents, parameters: parameters, headers: authHeader) { data, error in
            
            if let error = error {
                
                print("Error: \(error)")
                return
            }

            guard let result = data else {
                print("No data received")
                return
            }
            
            DispatchQueue.main.async {
                completion(result)
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
        
        networkService.performDataTask(url: requestURL, method: HTTPMethod.GET.rawValue, urlComponents: nil, parameters: nil, headers: headers) { data, error in
            
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
        
        
        networkService.performDataTask(url: requestURL, method: HTTPMethod.GET.rawValue, urlComponents: nil, parameters: nil, headers: headers) { data, error in
            
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
                let lookUp = field["lookup"] as! [String: Any]
                var lookUpApiName: String? = nil
                
                if !lookUp.isEmpty {
                    if let module = lookUp["module"] as? [String: Any], let apiName = module["api_name"] {
                        lookUpApiName = apiName as? String
                    }
                }
                
                if fieldApiName != "Modified_By" && fieldApiName != "Created_By" && fieldApiName != "Created_Time" && fieldApiName != "Modified_Time" && fieldApiName != "Last_Activity_Time" && fieldApiName != "Unsubscribed_Mode" && fieldApiName != "Unsubscribed_Time" && fieldApiName != "Owner" && fieldApiName != "Tag" {
                    
                    returnData.append(Field(fieldName: displayLabel, fieldType: jsonType, fieldApiName: fieldApiName, lookUpApiName: lookUpApiName))
                }
            }
            DispatchQueue.main.async {
//                print(1)
                completion(returnData)
            }
        }
    }
    
    
    // MARK: Currently not in use used to get fields for formTableVc now using getfieldMetaData
//    func getLayout(module: String, completion: @escaping ([Field]) -> Void ) -> Void {
//        let urlRequestString = "crm/v3/settings/layouts?module=\(module)"
//        let requestURL = URL(string: zohoApiURLString + urlRequestString)
//        var returnData = [Field]()
//
//        guard let requestURL else {
//            print("Not Valid")
//            return
//        }
//
//        let headers: [String: String] = [
//            "Zoho-oauthtoken \(accessToken)": "Authorization"
//        ]
//
//
//        networkService.performDataTask(url: requestURL, method: HTTPMethod.GET.rawValue, urlComponents: nil, parameters: nil, headers: headers) { data, error in
//
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//
//            let layouts = data["layouts"] as! Array<Any>
//
//            let layout = layouts[0] as! [String: Any]
//            let sections = layout["sections"] as! Array<Any>
//
//            for i in 0..<sections.count {
//                let fields = sections[i] as! [String: Any]
//                let field = fields["fields"] as! Array<Any>
//
//                for j in 0..<field.count {
//
//                    let type = field[j] as! [String: Any]
//                    let jsonType = type["json_type"] as! String
//                    let displayLabel = type["field_label"] as! String
//                    let fieldApiName = type["api_name"] as! String
//                    let lookUp = type["lookup"] as! [String: Any]
//                    var lookUpApiName: String? = nil
//
//                    if !lookUp.isEmpty {
//                        if let module = lookUp["module"] as? [String: Any], let apiName = module["api_name"] {
//                            lookUpApiName = apiName as? String
//                        }
//                    }
//
//                    if fieldApiName != "Modified_By" && fieldApiName != "Created_By" && fieldApiName != "Created_Time" && fieldApiName != "Modified_Time" && fieldApiName != "Last_Activity_Time" && fieldApiName != "Unsubscribed_Mode" && fieldApiName != "Unsubscribed_Time" && fieldApiName != "Owner" && fieldApiName != "Tag" {
////                        print(fieldApiName, "aaaa")
//                        returnData.append(Field(fieldName: displayLabel, fieldType: jsonType, fieldApiName: fieldApiName, lookUpApiName: lookUpApiName))
//                    }
//
//                }
//            }
//            DispatchQueue.main.async {
//                completion(returnData)
//            }
//        }
//    }
    
    func addRecord(module: String, recordData: [String: Any?], isAUpdate: Bool, recordId: String?) {
        
        var urlRequestString = "crm/v3/\(module)"
        let requestURL = URL(string: zohoApiURLString + urlRequestString)
        
        guard let requestURL else {
            print("Not Valid")
            return
        }
        
        let headers: [String: String] = [
            "Zoho-oauthtoken \(accessToken)": "Authorization"
        ]
        
        var data = recordData
        var httpMethod = HTTPMethod.POST.rawValue
        
        if isAUpdate {
            guard let recordId = recordId else { print("recordId Invalid"); return }
            
            data["id"] = recordId
            httpMethod =  HTTPMethod.PUT.rawValue
        }
        
        let parameter = ["data": [data]]
        
        
        networkService.performDataTask(url: requestURL, method: httpMethod, urlComponents: nil, parameters: parameter, headers: headers) { data, error in

            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let result = data else {
                print("No data received")
                return
            }
            
//            if dataisnot  {
//                addRecord(module: module, recordData: <#T##[String : Any?]#>, isAUpdate: <#T##Bool#>, recordId: <#T##String?#>)
//            }

            print(result)

        }
    }
    
    func getRecords(module: String, id: String?, completion: @escaping ([Any]) -> Void) ->Void {
        
        var urlRequestString = "crm/v3/\(module)"
        
        
        if let ids = id {
            urlRequestString.append("/")
            urlRequestString.append(ids)
        } else {
            urlRequestString.append("?fields=Name,Email")
        }
        
        let requestURL = URL(string: zohoApiURLString + urlRequestString)
        
        guard let requestURL else {
            print("Not Valid")
            return
        }
        
        let headers: [String: String] = [
            "Zoho-oauthtoken \(accessToken)": "Authorization"
        ]
        
        
        networkService.performDataTask(url: requestURL, method: HTTPMethod.GET.rawValue, urlComponents: nil, parameters: nil, headers: headers) { data, error in
            
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
    
    func deleteRecords(module: String, ids: [String], completion: @escaping ([Any]) -> Void) ->Void {
        var urlRequestString = "crm/v3/\(module)?ids="
        
        ids.forEach { id in
            urlRequestString = urlRequestString + id + ","
        }
        
        let requestURL = URL(string: zohoApiURLString + urlRequestString)
        
        guard let requestURL else {
            print("Not Valid")
            return
        }
        
        let headers: [String: String] = [
            "Zoho-oauthtoken \(accessToken)": "Authorization"
        ]
        
        
        networkService.performDataTask(url: requestURL, method: HTTPMethod.DELETE.rawValue, urlComponents: nil, parameters: nil, headers: headers) { data, error in
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            
            let recordsResult = data["data"] as! [Any]
            recordsResult.forEach { record in
                let data = record as! [String: Any]
                print(data["status"] as! String)
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
        
        
        networkService.performDataTask(url: requestURL, method: HTTPMethod.GET.rawValue, urlComponents: nil, parameters: nil, headers: headers) { data, error in
            
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
    
    private func setAccessToken() {
        
    }
    
    func getRegistrationURL() -> String {
        // MARK: Should be stored somewhere else
        
        let registerURLString = "https://accounts.zoho.com/oauth/v2/auth?scope=ZohoCRM.settings.ALL,ZohoCRM.users.ALL,ZohoCRM.modules.ALL&client_id=1000.24VNMCSZ1JRK4QJUA6L60NZA91C1KG&response_type=code&access_type=offline&redirect_uri=https://guhans6.github.io/logIn-20611/"
        
        return registerURLString
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
