//
//  FieldsNetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class FieldsNetworkService {
    
    let networkService = NetworkService()
    
    
    // MARK: USE JSON DECODING
    func getfieldMetaData(module: String, completion: @escaping ([Field]) -> Void ) -> Void {
        
        let urlRequestString = "crm/v3/settings/fields?module=\(module)"
//        var returnData = [Fiel]()
        
        networkService.performNetworkCall(url: urlRequestString, method: .GET, urlComponents: nil, parameters: nil, headers: nil) { data in
            
            let this = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let result = try decoder.decode(Fields.self, from: this)
                var fields = [Field]()
                
                result.fields.forEach { field in
                    
                    if field.apiName != "Modified_By" && field.apiName != "Created_By" && field.apiName != "Created_Time" && field.apiName != "Modified_Time" && field.apiName != "Last_Activity_Time" && field.apiName != "Unsubscribed_Mode" && field.apiName != "Unsubscribed_Time" && field.apiName != "Owner" && field.apiName != "Tag" {
                            
                        fields.append(field)
                    }
                }
                
//                print(fields)
                completion(fields)
            } catch {
                print(error)
            }
            
            
//            let fields = data["fields"] as! Array<Any>
//
//            for field in fields {
//
////                print(field)
//
//                let field = field as! [String: Any]
//                let jsonType = field["json_type"] as! String
//                let displayLabel = field["field_label"] as! String
//                let fieldApiName = field["api_name"] as! String
//                let lookUp = field["lookup"] as! [String: Any]
//                let dataType = field["data_type"] as! String
//                var lookUpApiName: String? = nil
//
//                if dataType == "multiselectpicklist" || dataType == "picklist" {
//                    let pickListValues = field["pick_list_values"] as! [[String: Any]]
//                    pickListValues.forEach { value in
//                        let picklistvalue = value["display_value"]
//                        let pickListId = value["id"] as! String
//                    }
//                }
//
//                if !lookUp.isEmpty {
//                    if let module = lookUp["module"] as? [String: Any], let apiName = module["api_name"] {
//                        lookUpApiName = apiName as? String
//                    }
//                }
//
//                if fieldApiName != "Modified_By" && fieldApiName != "Created_By" && fieldApiName != "Created_Time" && fieldApiName != "Modified_Time" && fieldApiName != "Last_Activity_Time" && fieldApiName != "Unsubscribed_Mode" && fieldApiName != "Unsubscribed_Time" && fieldApiName != "Owner" && fieldApiName != "Tag" {
//
//                    returnData.append(Fiel(fieldName: displayLabel, fieldType: jsonType, fieldApiName: fieldApiName, lookUpApiName: lookUpApiName, dataType: dataType))
//                }
//            }
//            completion(returnData)
        } failure: { error in
            print(error)
        }
    }
    
    
    // MARK: Currently not in use used to get fields for formTableVc now using getfieldMetaData
//    func getLayout(module: String, completion: @escaping ([Field]) -> Void ) -> Void {
//        let urlRequestString = "crm/v3/settings/layouts?module=\(module)"
//        let requestURL = URL(string: zohoApiURLString + urlRequestString)
//        var returnData = [Field]()
//
//        guard let requestURL else {
//            print("Not Valid")
//            return
//        }
//
//        let headers: [String: String] = [
//            "Zoho-oauthtoken \(accessToken)": "Authorization"
//        ]
//
//
//        networkService.performDataTask(url: requestURL, method: HTTPMethod.GET.rawValue, urlComponents: nil, parameters: nil, headers: headers) { data, error in
//
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//
//            let layouts = data["layouts"] as! Array<Any>
//
//            let layout = layouts[0] as! [String: Any]
//            let sections = layout["sections"] as! Array<Any>
//
//            for i in 0..<sections.count {
//                let fields = sections[i] as! [String: Any]
//                let field = fields["fields"] as! Array<Any>
//
//                for j in 0..<field.count {
//
//                    let type = field[j] as! [String: Any]
//                    let jsonType = type["json_type"] as! String
//                    let displayLabel = type["field_label"] as! String
//                    let fieldApiName = type["api_name"] as! String
//                    let lookUp = type["lookup"] as! [String: Any]
//                    var lookUpApiName: String? = nil
//
//                    if !lookUp.isEmpty {
//                        if let module = lookUp["module"] as? [String: Any], let apiName = module["api_name"] {
//                            lookUpApiName = apiName as? String
//                        }
//                    }
//
//                    if fieldApiName != "Modified_By" && fieldApiName != "Created_By" && fieldApiName != "Created_Time" && fieldApiName != "Modified_Time" && fieldApiName != "Last_Activity_Time" && fieldApiName != "Unsubscribed_Mode" && fieldApiName != "Unsubscribed_Time" && fieldApiName != "Owner" && fieldApiName != "Tag" {
////                        print(fieldApiName, "aaaa")
//                        returnData.append(Field(fieldName: displayLabel, fieldType: jsonType, fieldApiName: fieldApiName, lookUpApiName: lookUpApiName))
//                    }
//
//                }
//            }
//            DispatchQueue.main.async {
//                completion(returnData)
//            }
//        }
//    }
}
