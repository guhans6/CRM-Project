//
//  Fields.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 07/02/23.
//

import Foundation

struct Fiel { // Changed Fields to field
    
    let fieldName: String
    let fieldType: String
    let fieldApiName: String
    let lookUpApiName: String?
    let dataType: String
}

struct Fields: Codable {
    let fields: [Field]
}

// MARK: - Field
struct Field: Codable {
    let id: String
//    let currency: AutoNumber
    let pickListValues: [PickListValue]
    let customField: Bool
    let displayLabel: String
    let multiModuleLookup: Lookup
    let displayField: Bool
    let multiselectlookup: Lookup
    let apiName: String
    let displayType: Int
    let jsonType: String
//    let readOnly: Bool
    let fieldLabel: String
    let createdTime, modifiedTime: Date?
    let lookup: Lookup
    let dataType: String

    enum CodingKeys: String, CodingKey {
        case id
        case pickListValues = "pick_list_values"
        case customField = "custom_field"
        case displayLabel = "display_label"
        case multiModuleLookup = "multi_module_lookup"
        case displayField = "display_field"
        case multiselectlookup
        case apiName = "api_name"
        case displayType = "display_type"
        case jsonType = "json_type"
        case fieldLabel = "field_label"
        case createdTime = "created_time"
        case modifiedTime = "modified_time"
        case lookup
        case dataType = "data_type"
    }
}

// MARK: - AutoNumber
struct AutoNumber: Codable {
}

struct PickListValue: Codable {
    let displayValue, id: String
    let actualValue: String

    enum CodingKeys: String, CodingKey {
        case displayValue = "display_value"
        case id
        case actualValue = "actual_value"
    }
}

struct Lookup: Codable {
    let displayLabel, apiName, id: String?
    let module: Modul?

    enum CodingKeys: String, CodingKey {
        case displayLabel = "display_label"
        case apiName = "api_name"
        case id, module
    }
}

struct Modul: Codable {
    let id, apiName: String

    enum CodingKeys: String, CodingKey {
        case id
        case apiName = "api_name"
    }
}
