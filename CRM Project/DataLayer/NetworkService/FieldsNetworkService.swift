//
//  FieldsNetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class FieldsNetworkService {
    
    let networkService = NetworkService()
    
    private let id = "id"
    
    private let pickListValues = "pick_list_values"
    private let customField = "custom_field"
    private let displayLabel = "display_label"
    private let displayField = "display_field"
    private let apiName = "api_name"
    private let jsonType = "json_type"
    private let fieldLabel = "field_label"
    private let lookup = "lookup"
    private let dataType = "data_type"
    private let isSystemMandatory = "system_mandatory"
    
    private let displayValue = "display_value"
    private let actualValue = "actual_value"
    
    let sqliteText = " TEXT"
    let sqliteInt = " INTEGER"
    
    // MARK: USE JSON DECODING
    func getfieldMetaData(module: String, completion: @escaping ([Field]) -> Void ) -> Void {
        
        let urlRequestString = "crm/v3/settings/fields?module=\(module)"
//        var returnData = [Fiel]()
        
        networkService.performNetworkCall(url: urlRequestString, method: .GET, urlComponents: nil, parameters: nil, headers: nil) { data in
            
            
            let json = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let result = try decoder.decode(Fields.self, from: json)
                var fields = [Field]()
                
                result.fields.forEach { field in
                    
                    if field.apiName != "Modified_By" && field.apiName != "Created_By" && field.apiName != "Created_Time" && field.apiName != "Modified_Time" && field.apiName != "Last_Activity_Time" && field.apiName != "Unsubscribed_Mode" && field.apiName != "Unsubscribed_Time" && field.apiName != "Owner" && field.apiName != "Tag" {
                            
                        fields.append(field)
//                        print(field.pickListValues)
                        self.saveFieldToDataBase(field: field)
                    }
                }
                
                completion(fields)
            } catch {
                print(error)
            }
            
            
        } failure: { error in
            print(error)
        }
    }
    
    
    private func saveFieldToDataBase(field: Field) {
        
        
        let lookupId = "lookup_id"
        let lookupTableColumns = [
            lookupId.appending("\(sqliteText) PRIMARY KEY"),
            apiName.appending(sqliteText),
            displayLabel.appending(sqliteText),
        ]
        
        if Database.shared.createTable(tableName: "LookupTable", columns: lookupTableColumns) {
//            print("LookupTable Table Created Successfully")
        } else {
//            print("Failed LookupTable")
        }
        
        let fieldId = "field_id"
        let columns = [
            fieldId.appending("\(sqliteText) PRIMARY KEY"),
            displayLabel.appending(sqliteText),
            apiName.appending(sqliteText),
            jsonType.appending(sqliteText),
            customField.appending(sqliteInt),
            dataType.appending(sqliteText),
            isSystemMandatory.appending(sqliteInt),
            "picklist_id".appending(sqliteText),
            "lookup_id".appending(sqliteText),
            "FOREIGN KEY(\(lookupId)) REFERENCES LookupTable(\(lookupId))",
            
        ]
        
        if Database.shared.createTable(tableName: "Fields", columns: columns) {
//            print("Fields Table Created Successfully")
        } else {
//            print("Failed Fields")
        }
        
        let pickListId = "picklist_id"
        let pickListTableColumns = [
            pickListId.appending("\(sqliteText) PRIMARY KEY"),
            fieldId.appending(sqliteText),
            displayValue.appending(sqliteText),
            actualValue.appending(sqliteText),
            "FOREIGN KEY(\(fieldId)) REFERENCES Fields(\(fieldId))"
        ]
        
        if Database.shared.createTable(tableName: "PickListValues", columns: pickListTableColumns) {
//            print("PickListValues Table Created Successfully")
        } else {
//            print("Failed PickListValues")
        }
        
        var fieldDictionary  = [String: Any]()
        
        fieldDictionary[fieldId] = field.id
        fieldDictionary[displayLabel] = field.displayLabel
        fieldDictionary[apiName] = field.apiName
        fieldDictionary[jsonType] = field.jsonType
        fieldDictionary[customField] = field.customField
        fieldDictionary[dataType] = field.dataType
        fieldDictionary[isSystemMandatory] = field.isSystemMandatory
        fieldDictionary[lookupId] = field.lookup.module?.id
//        fieldDictionary[pickListId] =
        
        if Database.shared.insert(tableName: "Fields", values: fieldDictionary) {
//            print("yayy ")
        }
        
        
        field.pickListValues.forEach { pickListValue in
            
            var pickListDictionary = [String: Any]()
            pickListDictionary[pickListId] = pickListValue.id
            pickListDictionary[displayValue] = pickListValue.displayValue
            pickListDictionary[actualValue] = pickListValue.actualValue
            
            if Database.shared.insert(tableName: "PickListValues", values: pickListDictionary) {
//                print("pickList Successfull")
            }
        }
        
        var lookupDictionary = [String: Any]()
        
        lookupDictionary[lookupId] = field.lookup.module?.id
        lookupDictionary[apiName] = field.lookup.module?.apiName
        
//        print(l)
        
        if Database.shared.insert(tableName: "LookupTable", values: lookupDictionary) {
            print("pickList Successfull")
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
