//
//  KeychainService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class KeychainController {
    
    private let refreshTokenService = "com.zoho.refresh.crm"
    private let accessTokenService = "com.zoho.access.crm"
    private let clientService = "www.api.crm.zoho.com"
    private let account = "primary"
    private let clientIdAccount = "clientId"
    private let clientSecretAccount = "clientSecret"
    
    private let keychainManager = KeyChain()
    
    func storeRefreshToken(token: String) {
        
        guard let data = token.data(using: .utf8) else {
            print("Token can't be converted to data")
            return
        }
        
        do {
            try keychainManager.saveData(data: data, service: refreshTokenService, account: account)
            print("Refresh Token Saved Sucessfully")
        } catch {
            print(error)
        }
        
    }
    
    func saveClientIdAndSecret() {
        guard let clientId = "1000.24VNMCSZ1JRK4QJUA6L60NZA91C1KG".data(using: .utf8) else { return }
        guard let clientSecret = "b95187fae4e55ecc33ed8634712dfc31d65dfc8981".data(using: .utf8) else { return }
        try? keychainManager.saveData(data: clientId, service: clientService, account: clientIdAccount)
        try? keychainManager.saveData(data: clientSecret, service: "www.api.crm.zoho.com", account: "clientSecret")
    }
    
    func storeAccessToken(accessToken: String) {
        
        guard let data = accessToken.data(using: .utf8) else {
            print("Token can't be converted")
            return
        }
        
        do {
            try keychainManager.saveData(data: data, service: accessTokenService, account: account)
            print("Auth Token Saved Sucessfully")
        } catch {
            print(error)
        }
    }
    
    func getClientId() -> String {
        let clientId = try? keychainManager.retreiveFromKeyChain(service: clientService, account: clientIdAccount)
        
        if clientId == nil {
            saveClientIdAndSecret()
            return getClientId()
        }
        return String(data: clientId!, encoding: .utf8)!

    }
    
    func getClientSecret() -> String {
        let clientSecret = try? keychainManager.retreiveFromKeyChain(service: clientService, account: clientSecretAccount)
        
        if clientSecret == nil {
            saveClientIdAndSecret()
            return getClientSecret()
        }
        return String(data: clientSecret!, encoding: .utf8)!

    }
    
    func getRefreshToken() -> String {
        
        do {
            let refresh = try keychainManager.retreiveFromKeyChain(service: refreshTokenService, account: account)
            print(String(data: refresh!, encoding: .utf8)!)
            
            return String(data: refresh!, encoding: .utf8)!
        } catch {
            print(error)
        }
        return ""
    }
    
    func getAccessToken() -> String {
        let access = try! keychainManager.retreiveFromKeyChain(service: accessTokenService, account: account)
        let accessToken = String(data: access!, encoding: .utf8)!
        
        return accessToken
    }
    
    // Update Refresh Token
    func updateRefreshToken() {
        
    }
    
    // Delete user Tokens
    func deleteAuthToken() {
        keychainManager.deleteToken(service: clientService, account: clientSecretAccount)
    }
}
