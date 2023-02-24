//
//  Table.swift
//  CRM C
//
//  Created by guhan-pt6208 on 24/02/23.
//

import Foundation


struct Table {
    
    let id: String
    let name: String
    let seatingCapacity: String
    let tableLocation: String
}

//struct TableData: Codable {
//    let data: [Table]
//}
//
//// MARK: - Datum
//struct Table: Codable {
//    let tableLocation, id, seatingCapacity, name: String
//
//    enum CodingKeys: String, CodingKey {
//        case tableLocation = "Table_Location"
//        case id
//        case seatingCapacity = "Seating_Capacity"
//        case name = "Name"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(String.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//
////        self.seatingCapacity = try container.decode(String.self, forKey: .seatingCapacity)
//
//        if let seatingCapacity = try container.decodeIfPresent(String.self, forKey: .seatingCapacity) {
//
//            self.seatingCapacity  = seatingCapacity
//        } else if let seatingCapacity = try container.decodeIfPresent(String.self, forKey: .init(stringValue: "Booking_Table.Seating_Capacity")!) {
//
//            self.seatingCapacity = seatingCapacity
//        } else {
//
//            throw DecodingError.keyNotFound(CodingKeys.seatingCapacity, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not find key for seating Capacity"))
//        }
//
//        if let tableLocation = try container.decodeIfPresent(String.self, forKey: .tableLocation) {
//
//            self.tableLocation = tableLocation
//        } else if let bookingTableLocation = try container.decodeIfPresent(String.self, forKey: .init(stringValue: "Booking_Table.Table_Location")!) {
//
//            self.tableLocation = bookingTableLocation
//        } else {
//            // If neither key value is found, throw an error
//            throw DecodingError.keyNotFound(CodingKeys.tableLocation, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not find key for table location"))
//        }
//    }
//}
