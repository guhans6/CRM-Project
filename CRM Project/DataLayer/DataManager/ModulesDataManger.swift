//
//  ModulesDataManger.swift
//  CRM C
//
//  Created by guhan-pt6208 on 19/02/23.
//

import Foundation

class ModulesDataManager {
    
    private let networkService = ModulesNetworkService()
    private let databaseService = ModulesDatabaseService()
    
    private let tableName = "Modules"
    private let moduleId = "id"
    private let moduleApiName = "api_name"
    private let modulePluralName = "plural_label"
    private let moduleSingularName = "singular_label"
    
    func getModules(completion: @escaping ([Module]) -> Void) -> Void {
    
            getModulesFromDatabase { modules in
                
                completion(modules)
            }
            
            getModulesFromNetwork { modules in
                
                completion(modules)
            }
        
    }
    
    private func getModulesFromDatabase(completion: @escaping ([Module]) -> Void ) {
        
        databaseService.getAllModulesFromDataBase { [weak self] modules in
            var customModules = [Module]()
            
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
    
    private func getModulesFromNetwork(completion: @escaping ([Module]) -> Void) -> Void {
        
        var customModules = [Module]()
        networkService.getModules { [weak self] modules in
            
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
                    self?.databaseService.insertModuleInTable(module: convertedModule)
                }
            }
            
            completion(customModules)
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
}
