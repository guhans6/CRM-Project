//
//  RelatedList.swift
//  CRM C
//
//  Created by guhan-pt6208 on 23/02/23.
//

import Foundation

// MARK: - RelatedList
struct RelatedList: Codable {
    let sequenceNumber, displayLabel: String
    let customizeFields: Bool
    let apiName: String
    let module: RelatedListModule
    let customizeDisplayLabel: Bool
    let name: String
    let id: String
    let type: TypeEnum

    enum CodingKeys: String, CodingKey {
        case sequenceNumber = "sequence_number"
        case displayLabel = "display_label"
        case customizeFields = "customize_fields"
        case apiName = "api_name"
        case module
        case customizeDisplayLabel = "customize_display_label"
        case name, id, type
    }
}

// MARK: - Module
struct RelatedListModule: Codable {
    let apiName, id: String

    enum CodingKeys: String, CodingKey {
        case apiName = "api_name"
        case id
    }
}

enum TypeEnum: String, Codable {
    case customLookup = "custom_lookup"
    case typeDefault = "default"
}
