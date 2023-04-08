//
//  DatabaseController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 05/04/23.
//

import Foundation

class DatabaseController {
    
    
    func clearAllData() {
        
        DatabaseService.shared.deleteAllTables()
    }
}
