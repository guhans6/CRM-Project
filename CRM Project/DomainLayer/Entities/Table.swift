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
    let seatingCapacity: String?
    let tableLocation: String?
    
    init(id: String, name: String, seatingCapacity: String?, tableLocation: String?) {
        self.id = id
        self.name = name
        self.seatingCapacity = seatingCapacity
        self.tableLocation = tableLocation
    }
}
