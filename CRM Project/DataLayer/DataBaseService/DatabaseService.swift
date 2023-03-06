//
//  DatabaseService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 06/03/23.
//

import Foundation

class DatabaseService {
    
    static let shared = DatabaseService()
    
    private let database = Database.shared
    
    
    // Modules Table columns
    private let modulesTableName = "Modules"
    private let moduleId = "id"
    private let moduleApiName = "api_name"
    private let modulePluralName = "plural_label"
    private let moduleSingularName = "singular_label"
    
    // Records Table Column
    private let recordsTableName = "Records"
    private let recordIdColumn = "id"
    private let recordNameColumn = "record_name"
    private let secondaryDataColumn = "secondary_data"
    
    private let usersTableName = "Users"
    private let userdIdColumn = "id"
    private let userFullName = "full_name"
    private let userEmail = "email"
    
    private let sqliteText = " TEXT"
    
    private init() { }
    
    
    func createAllTables() {
        
        createModulesTable()
        createRecordsTable()
    }
    
    private func createModulesTable() {
        
        let columns = [
            moduleId.appending("\(sqliteText) PRIMARY KEY"),
            moduleApiName.appending(sqliteText),
            modulePluralName.appending(sqliteText),
            moduleSingularName.appending(sqliteText)
        ]
        
        if database.createTable(tableName: modulesTableName, columns: columns) == false {
//            print("Modules Table Created Successfully")
            print(database.errorMsg)
        }
    }
    
    private func createRecordsTable() {
        
        let columns = [
            recordIdColumn.appending("\(sqliteText) PRIMARY KEY"),
            recordNameColumn.appending(sqliteText),
            secondaryDataColumn.appending(sqliteText)
        ]

        if database.createTable(tableName: recordsTableName, columns: columns) == false {

            print(database.errorMsg)
        }
        
    }
    
    private func createUsers() {
        
        let columns = [
            userdIdColumn.appending("\(sqliteText) PRIMARY KEY"),
            userFullName.appending(sqliteText),
            userEmail.appending(sqliteText)
        ]
        
        if database.createTable(tableName: usersTableName, columns: columns) == false {

            print(database.errorMsg)
        }
    }
}
