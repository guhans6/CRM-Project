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
    private let firstTimeLoginKey = "firstTime"
    private let gridViewKey = "view"
    private let timeKey = "time"
    private var loggedIn = false
    private var isFirstTime = true
    private var isGridViewPicked = true
    
    private init() {
        saveLastPickedView()
    }
    
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
    
    func isFirstTimeLogin() -> Bool {
        return userDefaults.bool(forKey: firstTimeLoginKey)
    }
    
    func setFirstTimeLogin(to value: Bool) {
        isFirstTime = value
        saveIsUserFirst()
    }
    
    func saveIsUserFirst() {
        userDefaults.set(isFirstTime, forKey: firstTimeLoginKey)
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
    
    func isLastPickedViewGrid() -> Bool {
        
        isGridViewPicked = userDefaults.bool(forKey: gridViewKey)
        return isGridViewPicked
    }
    
    func setLastPickedView(equalTo value: Bool) {
        isGridViewPicked = value
        saveLastPickedView()
    }
    
    private func saveLastPickedView() {
        userDefaults.set(isGridViewPicked, forKey: gridViewKey)
    }
}
