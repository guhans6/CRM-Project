//
//  NetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation
import UIKit

/// This is for the type of error in network
enum NetworkError: Error, Equatable {
    
    case invalidURLError(String)
    case incorrectDataError(String)
    case invalidOauthTokenError(String)
    case emptyDataError

}

class NetworkService {
    
    private let network: NetworkContract = Network.shared
    private let keychainService = KeychainController()
    private let userDefaults = UserDefaultsManager.shared
    
    private let zohoURLString = "https://accounts.zoho.com/"
    private let zohoApiURLString = "https://www.zohoapis.com/"       //MARK: ALSO ADD CRM V3
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
        keychainService.getClientId()
    }
    private var clientSecret: String {
        keychainService.getClientSecret()
    }
    
    func generateAccessToken(from url: URL?, completion: @escaping (Bool) -> Void) throws {
        
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
        network.getAuthToken(url: zohoURL, method: HTTPMethod.POST.rawValue, components: requestBodyComponents) { data, error in
            
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
                
                guard let refreshToken = json["refresh_token"] as? String,
                      let accessToken = json["access_token"] as? String
                else {
                    print("error converting access or refresh token")
                    return
                }
                
                self.keychainService.storeRefreshToken(token: refreshToken)
                self.keychainService.storeAccessToken(accessToken: accessToken)
                self.token = accessToken
                
                UserDefaultsManager.shared.setLogIn(equalTo: true)
                print("Login Success")
                completion(true)
                
            } catch let jsonError {
                print("Error decoding JSON: \(jsonError)")
                completion(false)
            }
        }
    }
    
    func generateAuthToken(completion: @escaping (String) -> Void) -> Void {
        
        let refreshToken = keychainService.getRefreshToken()
        
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
        
        network.getAuthToken(url: zohoURL, method: HTTPMethod.POST.rawValue, components: requestBodyComponents) { data, error in
            
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
                
                guard let accessToken = json["access_token"] as? String else {
                    print(("Cannot get access Token, \(json)"))
                    return
                }
                
                self.keychainService.storeAccessToken(accessToken: accessToken)
                self.userDefaults.saveTokenGeneratedTime()
                self.token = accessToken
                print("AccessToken Generated \(accessToken)")
                
                completion(accessToken)
                
            } catch let jsonError {
                print("Error decoding JSON: \(jsonError)")
            }
        }
    }
    
    func performNetworkCall(url: String, method: HTTPMethod, urlComponents: [String: String]?, parameters: [String: Any]?, headers: [String: String]?, success: @escaping ([String: Any]?, Error?) -> Void) -> Void {
        
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
        
        network.performDataTask(url: requestURL, method: method.rawValue, urlComponents: requestBodyComponents, parameters: parameters, header: authHeader) { data, error  in
            
            if let error = error {
                
                let nsError = error as NSError
                
                if nsError.userInfo["NSDebugDescription"] as! String == "Unable to parse empty data." {
                    success(nil, NetworkError.emptyDataError)
                    return
                }
                
                success(nil, error)
                return
            }
            
            guard let data = data else {
            
                success(nil, NetworkError.emptyDataError)
                return
            }
            
            if self.isInvalidTokenResponse(data: data) {
                
                self.generateAuthToken { accessToken in
                    
                    self.performNetworkCall(url: url, method: method, urlComponents: urlComponents, parameters: parameters, headers: headers, success: success)
                }
               
            } else {
                
                success(data, nil)
            }
        }
        
    }
    
    private func isInvalidTokenResponse(data: [String: Any]) -> Bool {
        
        if data["code"] as? String == "INVALID_TOKEN" {
            return true
        }
        return false
    }
    
    private func getAccessToken() -> String {
        
        let lastGeneratedTime = userDefaults.getLastTokenGenereatedTime()
        
        if Date().timeIntervalSinceReferenceDate - lastGeneratedTime.timeIntervalSinceReferenceDate >= 3480 {
            self.generateAuthToken { accessToken in
                
            }
            
        }
        return keychainService.getAccessToken()
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
        
        
        network.performDataTask(url: requestURL, method: HTTPMethod.GET.rawValue, urlComponents: nil, parameters: nil, header: headers) { data, error in
            
            if let error = error {
                print(error.localizedDescription)
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
    
    func getRegistrationURL() -> String {
        // MARK: Should be stored somewhere else
        
        let registerURLString = "https://accounts.zoho.com/oauth/v2/auth?scope=ZohoCRM.settings.ALL,ZohoCRM.users.ALL,ZohoCRM.modules.ALL,ZohoCRM.coql.READ,ZohoCRM.send_mail.all.CREATE,ZohoCRM.notifications.All&client_id=1000.24VNMCSZ1JRK4QJUA6L60NZA91C1KG&response_type=code&access_type=offline&redirect_uri=https://guhans6.github.io/logIn-20611/"
        
        return registerURLString
    }
    
    func uploadImage(photoData: UIImage?, module: String, recordId: String, completion: @escaping (Bool) -> Void)  {
        
        guard let photo = photoData?.pngData() else {
            print("No image")
            return
        }
        
        let requestURLString = zohoApiURLString.appending("crm/v3/\(module)/\(recordId)/photo?restrict_triggers=workflow")
        
        let requestURL = URL(string: requestURLString)
        
        guard let requestURL = requestURL else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = "POST"
        request.addValue("Zoho-oauthtoken \(accessToken)", forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"

        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"img1.png\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        body.append(photo)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        Network.shared.uploadLeadPhoto(url: requestURL,
                                       authToken: accessToken,
                                       request: request,
                                       body: body)
        { result, error in
            
            if let _ = error {
                print("error uploading photo")
                completion(false)
                return
            }
            
            guard let result = result, let code = result["code"] as? String else {
                print("error in imageUpload result")
                completion(false)
                return
            }
            
            if code == "SUCCESS" {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    func downloadImage(url: String,
                       module: String,
                       recordId: String,
                       completion: @escaping (Data?) -> Void) -> Void {
        
        let requestURLString = zohoApiURLString.appending(url)
        
        let requestURL = URL(string: requestURLString)
        
        guard let requestURL = requestURL else {
            print("Invalid URL")
            return
        }
        
        let authHeader: [String: String] = ["Zoho-oauthtoken \(accessToken)": "Authorization"]
        
        network.downloadImage(url: requestURL, header: authHeader) { imageData in
            
            completion(imageData)
        }
    }
}
