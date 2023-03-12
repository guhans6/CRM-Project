//
//  Fields.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 07/02/23.
//

import Foundation

struct Fields: Codable {
    let fields: [Field]
}

// MARK: - Field
struct Field: Codable {
    let id: String
    let pickListValues: [PickListValue]
    let customField: Bool
    let displayLabel: String
    let multiModuleLookup: Lookup
    let multiselectlookup: Lookup
    let apiName: String
    let jsonType: String
    let fieldLabel: String
    let lookup: Lookup
    let dataType: String
    let isSystemMandatory: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case pickListValues = "pick_list_values"
        case customField = "custom_field"
        case displayLabel = "display_label"
        case multiModuleLookup = "multi_module_lookup"
        case multiselectlookup
        case apiName = "api_name"
        case jsonType = "json_type"
        case fieldLabel = "field_label"
        case lookup
        case dataType = "data_type"
        case isSystemMandatory = "system_mandatory"
        
    }
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
    
    let module: FieldModule?

    enum CodingKeys: String, CodingKey {
        case module
    }
}

struct FieldModule: Codable {
    
    let id: String
    let apiName: String

    enum CodingKeys: String, CodingKey {
        case id
        case apiName = "api_name"
    }
}
