//
//  FieldsDataManager.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class FieldsDataManager {

    let fieldNetworkService = FieldsNetworkService()

    func getfieldMetaData(module: String, completion: @escaping ([Field]) -> Void ) -> Void {

        fieldNetworkService.getfieldMetaData(module: module) { dat in
            
            let data = [String: Any]()
            var returnData = [Field]()
            let fields = data["fields"] as! Array<Any>
            
            for field in fields {
                
                //                print(field)
                
                guard let field = field as? [String: Any] else {
                    print("No fields")
                    return
                }
                let id = field["id"] as! String
                let jsonType = field["json_type"] as! String
                let displayLabel = field["field_label"] as! String
                let fieldApiName = field["api_name"] as! String
                let lookUp = field["lookup"] as! [String: Any]
                let dataType = field["data_type"] as! String
                var lookUpApiName: String? = nil
                
                if dataType == "multiselectpicklist" || dataType == "picklist" {
                    let pickListValues = field["pick_list_values"] as! [[String: Any]]
                    pickListValues.forEach { value in
                        let picklistvalue = value["display_value"]
                        let pickListId = value["id"] as! String
                    }
                }
                
                if !lookUp.isEmpty {
                    if let module = lookUp["module"] as? [String: Any], let apiName = module["api_name"] {
                        lookUpApiName = apiName as? String
                    }
                }
                
                if fieldApiName != "Modified_By" && fieldApiName != "Created_By" && fieldApiName != "Created_Time" && fieldApiName != "Modified_Time" && fieldApiName != "Last_Activity_Time" && fieldApiName != "Unsubscribed_Mode" && fieldApiName != "Unsubscribed_Time" && fieldApiName != "Owner" && fieldApiName != "Tag" {
                    
//                    returnData.append(Fiel(fieldName: displayLabel, fieldType: jsonType, fieldApiName: fieldApiName, lookUpApiName: lookUpApiName, dataType: dataType))
//                   
                }
            }
            completion(returnData)
        }
        
        
    }
}
