//
//  ModulesDataManger.swift
//  CRM C
//
//  Created by guhan-pt6208 on 19/02/23.
//

import Foundation

class ModulesDataManager {
    
    let networkService = ModulesNetworkService()
    
    private let tableName = "Modules"
    private let moduleId = "id"
    private let moduleApiName = "api_name"
    private let modulePluralName = "plural_label"
    private let moduleSingularName = "singular_label"
    
    let sqliteText = " TEXT"
    
    func getModules(completion: @escaping ([Module]) -> Void) -> Void {
        
        var customModules = [Module]()
        print(NetworkMonitor.shared.isConnected)
        if NetworkMonitor.shared.isConnected {
            
            networkService.getModules { [weak self] modules in
                
                
//                let modules = data["modules"] as! Array<Dictionary<String, Any>>
                
                modules.forEach { module in
                    
                    
                    guard let generatedType = module["generated_type"] as? String else {
                        print("Can't Parse module")
                        return
                    }
                    
                    // Only need custom modules
                    if generatedType == "custom" {
                        
                        guard let convertedModule = self?.convertToModule(module: module) else {
                            print("Error in converting module to struct")
                            return
                        }
                        customModules.append(convertedModule)
                    }
                }
                
                completion(customModules)
                self?.createModuleTable(modules: customModules)
            }
            
        } else {
            
            networkService.getAllModulesFromDataBase { [weak self] modules in
                
                print("from Database")
        
                modules.forEach { module in
                
                    guard let convertedModule = self?.convertToModule(module: module) else {
                        print("Error in converting module to struct")
                        return
                    }
                    customModules.append(convertedModule)
                }
                completion(customModules)
            }
        }
    }
    
    private func convertToModule(module: [String: Any]) -> Module? {
        
        guard let id = module[moduleId] as? String,
              let apiName = module[moduleApiName] as? String,
              let pluralLabel = module[modulePluralName] as? String,
              let singularLabel = module[moduleSingularName] as? String
        else {
            return nil
        }
        
        return Module(id: id,apiName: apiName, modulePluralName: pluralLabel, moduleSingularName: singularLabel)
        
    }
    
    func createModuleTable(modules: [Module]) {
        
//        let idColumn = "Module_id"
        
        for module in modules {
            var moduleDictionary = [String: Any]()
            
            moduleDictionary[moduleId] = module.id
            moduleDictionary[moduleApiName] = module.apiName
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
