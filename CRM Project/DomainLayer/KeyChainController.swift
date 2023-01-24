//
//  KeyChainController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 21/01/23.
//

import Foundation

class KeyChainController {
    
    private let refreshTokenService = "com.zoho.refresh.crm"
    private let accessTokenService = "com.zoho.access.crm"
    private let account = "primary"
    
    private let keychainManager = KeyChainManager()
    
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
    
    func getRefreshToken() {
        
        do {
            let refresh = try keychainManager.retreiveFromKeyChain(service: refreshTokenService, account: account)
            print(String(data: refresh!, encoding: .utf8)!)
        } catch {
            print(error)
        }
        
    }
    
    func getAccessToken() {
        do {
            let access = try keychainManager.retreiveFromKeyChain(service: accessTokenService, account: account)
            print(String(data: access!, encoding: .utf8)!)
        } catch {
            print(error)
        }
    }
    
    // Update Refresh Token
    func updateRefreshToken() {
        
    }
    
    // Delete user Tokens
    func deleteAuthToken() {
        keychainManager.deleteToken(service: refreshTokenService, account: account)
    }
}
