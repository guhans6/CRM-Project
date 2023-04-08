//
//  ModulesDatabaseService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 06/03/23.
//

import Foundation

class ModulesDatabaseService {
    
    // Modules Table columns
    private let modulesTableName = "Modules"
    private let moduleId = "id"
    private let moduleApiName = "api_name"
    private let modulePluralName = "plural_label"
    private let moduleSingularName = "singular_label"
    
    private let database = Database.shared
    
    func createModulesTable() {
        let sqliteText = DatabaseService.text
        
        let columns = [
            moduleId.appending("\(sqliteText) PRIMARY KEY"),
            moduleApiName.appending(sqliteText),
            modulePluralName.appending(sqliteText),
            moduleSingularName.appending(sqliteText)
        ]
        
        if database.createTable(tableName: modulesTableName, columns: columns) == false {
            print(database.errorMsg)
        }
    }
    
    func getAllModulesFromDataBase(completion: @escaping ([[String: Any]]) -> Void ) {
        
        database.select(tableName: modulesTableName) { result in
            
            guard let result = result else {
                print("Module result nil db")
                return
            }
            completion(result)
        }
    }
    
    func insertModuleInTable(module: Module) {
        
        var moduleDictionary = [String: Any]()
        
        moduleDictionary[moduleId] = module.id
        moduleDictionary[moduleApiName] = module.apiName
        moduleDictionary[modulePluralName] = module.modulePluralName
        moduleDictionary[moduleSingularName] = module.moduleSingularName
        
        if database.insert(tableName: modulesTableName, values: moduleDictionary) == false {
            print(database.errorMsg)
        }
        
    }
    
    func deleteModulesTable() {
        
        if database.drop(tableName: modulesTableName) == false {
            print(database.errorMsg)
        }
    }
}
