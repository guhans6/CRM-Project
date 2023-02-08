//
//  KeyChainManager.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 22/01/23.
//

import Foundation

enum KeyChainError: Error {
    case duplicateEntryError
    case passwordNotFoundError
    case unhandledError(status: OSStatus)
}

class KeyChainManager {
    
    //    saveAuthToken
    
    func saveData(data: Data, service: String, account: String) throws {
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: data as AnyObject
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            print("Item already present So Updating it with new one")
            updateRefreshToken(with: data, service: service, account: account)
        } else if status != errSecSuccess {
            print("No success")
            throw KeyChainError.unhandledError(status: status)
        }
    }
    
    func retreiveFromKeyChain(service: String, account: String) throws -> Data? {
        
        var result: CFTypeRef? = nil
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecItemNotFound {
            throw KeyChainError.passwordNotFoundError
        } else if status != errSecSuccess {
            throw KeyChainError.unhandledError(status: status)
        }
        
        return result as? Data
    }
    
    private func updateRefreshToken(with data: Data, service: String, account: String) {
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service]
        let attributes: [String: Any] = [kSecAttrAccount as String: account,
                                         kSecValueData as String: data]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        guard status != errSecItemNotFound else {
            print("Not found")
            return
        }
        
        guard status == errSecSuccess else {
            print("OS Errors \(status)")
            return
        }
        
        print("Success \(String(data: data, encoding: .utf8)!)")
    }
    
    func deleteToken(service: String, account: String) {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecItemNotFound {
            print("Data can't be found so can't delete")
        }
        
        if status == errSecSuccess {
            print("Deleted Successfully")
        }
    }
    
}
