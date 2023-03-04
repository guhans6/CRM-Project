//
//  ModulesService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class ModulesNetworkService {
    
    private let networkService = NetworkService()
    
    private let tableName = "Modules"
    private let moduleId = "Module_id"
    private let apiName = "api_name"
    private let modulePluralName = "modulePluralName"
    private let moduleSingularName = "moduleSingularName"
    
    let sqliteText = " TEXT"
    
    func getModules(completion: @escaping ([Module]) -> Void) -> Void {
        
        let urlRequestString = "crm/v3/settings/modules"

        networkService.performNetworkCall(url: urlRequestString, method: .GET, urlComponents: nil, parameters: nil, headers: nil) { data in
            
            let modules = data["modules"] as! Array<Any>
            var customModules = [Module]()
            modules.forEach { module in
    
                let module = module as! [String: Any]
                if let generatedType = module["generated_type"] as? String, generatedType == "custom" {
                    let id = module["id"] as! String
                    let apiName = module["api_name"] as! String
                    let pluralLabel = module["plural_label"] as! String
                    let singularLabel = module["singular_label"] as! String

                    customModules.append(Module(id: id,apiName: apiName, modulePluralName: pluralLabel, moduleSingularName: singularLabel))
                } else {
                    print("Can't Parse module")
                }
            }
            
            completion(customModules)
            self.createModuleTable(modules: customModules)
        } failure: { error in
            print(error)
        }
    }
        
    
    func getAllModules() {
        
        let result = Database.shared.select(tableName: tableName, addition: "ORDER BY \(moduleSingularName) DESC")
        
        result?.forEach({ abc in
            print(abc[moduleId])
        })
    }
    
    func createModuleTable(modules: [Module]) {
        
//        let idColumn = "Module_id"
        let columns = [
            moduleId.appending(" INTEGER PRIMARY KEY"),
            apiName.appending(sqliteText),
            modulePluralName.appending(sqliteText),
            moduleSingularName.appending(sqliteText)
        ]
        
        if Database.shared.createTable(tableName: tableName, columns: columns) {
            print("Modules Table Created Successfully")
        } else {
            print("Failed Modules")
        }
        
        for module in modules {
            var moduleDictionary = [String: Any]()
            
            moduleDictionary[moduleId] = module.id
            moduleDictionary[apiName] = module.apiName
            moduleDictionary[modulePluralName] = module.modulePluralName
            moduleDictionary[moduleSingularName] = module.moduleSingularName
            
            if Database.shared.insert(tableName: "Modules", values: moduleDictionary) {
                print("Modules added to db")
            } else {
                print("errr")
            }
        }
        
    }

}
