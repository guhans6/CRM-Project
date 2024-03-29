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
    private let userFirstName = "firstName"
    
    private let database = Database.shared
    
    func createUsersTable() {
        
        let columns = [
            userdIdColumn.appending("\(DatabaseService.text) \(DatabaseService.primaryKey)"),
            userFullName.appending(DatabaseService.text),
            userEmail.appending(DatabaseService.text),
            userFirstName.appending(DatabaseService.text)
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
        userDictionary[userFirstName] = user.firstName
        
        if Database.shared.insert(tableName: usersTableName, values: userDictionary) == false {
            print(Database.shared.errorMsg)
        }
    }
    
    func getUser(completion: @escaping (User) -> Void) {
        
        database.select(tableName: usersTableName) { [weak self] result in
            
            if let result = result,
               result.count > 0 {
                
                if let user = self?.convertToUser(data: result[0]) {
                    completion(user)
                }
            }
        }
    }
    
    func convertToUser(data: [String: Any]) -> User? {
        
        guard let userId = data[userdIdColumn] as? String,
              let userFullName = data[userFullName] as? String,
              let userEmail = data[userEmail] as? String,
              let firstName = data[userFirstName] as? String  else
        {
            
            print("Error in User parsing")
            return nil
        }
        
        let user = User(id: userId, fullName: userFullName, email: userEmail, firstName: firstName)
        return user
    }
    
    func deleteUserTable() {
        
        if database.drop(tableName: usersTableName) == false {
            print(database.errorMsg)
        } else {
            print("success aaa")
        }
    }
}
