//
//  UserDefaultsManager.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 24/01/23.
//

import Foundation

class UserDefaultsManager {
    
    
    static let shared = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard
    private let loggedInKey = "isLoggedIn"
    private let timeKey = "time"
    private var loggedIn = false
    
    private init() { }
    
    
    func isUserLoggedIn() -> Bool {
        loggedIn = userDefaults.bool(forKey: loggedInKey)
        return loggedIn
    }
    
    func setLogIn(equalTo value: Bool) {
        loggedIn = value
        saveLoginBool()
    }
    
    private func saveLoginBool() {
        userDefaults.set(loggedIn, forKey: loggedInKey)
    }
    
    func saveTokenGeneratedTime() {
        let date = Date()
        userDefaults.set(date, forKey: timeKey)
    }
    
    func getLastTokenGenereatedTime() -> Date {
        if let date = userDefaults.object(forKey: timeKey) as? Date {
            return date
        } else {
            return Date()
        }
    }
    
}
