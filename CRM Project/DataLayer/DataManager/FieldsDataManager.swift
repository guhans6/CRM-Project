//
//  FieldsDataManager.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class FieldsDataManager {

    private let fieldNetworkService = FieldsNetworkService()
    private let databaseService = FieldsDatabaseService()

    func getfieldMetaData(module: String, completion: @escaping ([Field]) -> Void ) -> Void {
        
        self.databaseService.getFieldMetadata(module: module) { fields in
            
            completion(fields)
        }
        
        self.getFieldsFromNetwork(module: module) { fields in
            completion(fields)
        }
        
    }
    
    private func getFieldsFromNetwork(module: String,  completion: @escaping ([Field]) -> Void) -> Void {
        
        fieldNetworkService.getfieldMetaData(module: module) { [weak self] data in

            do {
                
                let json = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let result = try decoder.decode(Fields.self, from: json)
                var fields = [Field]()
                
                for field in result.fields {

                    if field.apiName == "Modified_By"
                        || field.apiName == "Created_By" || field.apiName == "Created_Time"
                        || field.apiName == "Modified_Time" || field.apiName == "Last_Activity_Time"
                        || field.apiName == "Unsubscribed_Mode" || field.apiName == "Unsubscribed_Time"
                        || field.apiName == "Owner" || field.apiName == "Tag" || field.apiName == "Exchange_Rate"
                        || field.apiName == "Locked__s"
                    {

                        continue
                    } else {
                        
                        fields.append(field)
                        self?.databaseService.saveFieldToDataBase(field: field, module: module)
                    }
                }

                completion(fields)

            } catch {

                print(error)
            }
        }
    }
}
