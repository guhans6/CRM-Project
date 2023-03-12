//
//  DatabaseService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 06/03/23.
//

import Foundation

class DatabaseService {
    
    static let shared = DatabaseService()
    
    static let sqliteText = " TEXT"
    static let sqliteInt = " INTEGER"
    static let primaryKey = " PRIMARY KEY"
    static let foreignKey = "FOREIGN KEY"
    static let references = " REFERENCES"
    
    private init() { }
    
    
    func createAllTables() {
        
        ModulesDatabaseService().createModulesTable()
        RecordsDatabaseService().createRecordsTable()
        UserDatabaseService().createUsers()
        FieldsDatabaseService().createFieldsTable()
    }
}
