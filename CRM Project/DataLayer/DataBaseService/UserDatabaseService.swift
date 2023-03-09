//
//  UserDatabaseService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 09/03/23.
//

import Foundation

class UserDatabaseService {
    
    // User Table Column
    private let usersTableName = "Users"
    private let userdIdColumn = "id"
    private let userFullName = "full_name"
    private let userEmail = "email"
    
    private let database = Database.shared
    
    func createUsers() {
        
        let columns = [
            userdIdColumn.appending("\(DatabaseService.sqliteText) \(DatabaseService.primaryKey)"),
            userFullName.appending(DatabaseService.sqliteText),
            userEmail.appending(DatabaseService.sqliteText)
        ]
        
        if database.createTable(tableName: usersTableName, columns: columns) == false {

            print(database.errorMsg)
        }
    }
    
    func saveUser(user: User) {
        
        var userDictionary = [String: Any]()
        
        userDictionary[userdIdColumn] = user.id
        userDictionary[userFullName] = user.fullName
        userDictionary[userEmail] = user.email
        
        if Database.shared.insert(tableName: usersTableName, values: userDictionary) == false {
            print(Database.shared.errorMsg)
        }
    }
}
