//
//  TableBookingDatabaseService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 13/03/23.
//

import Foundation

class BookingDatabaseService {
    
    private let database = Database.shared
    private let tableName = "Reservations"
    
    func getAvailableTables(date: String, time: String?, completion: @escaping ([[String: Any]]?) -> Void) {
        
        var whereClause = "Booking_Date = '\(date)'"
        
        if let time = time {
            whereClause.append(" AND Pick_List_1 ='\(time)'")
        }
        
        database.select(tableName: tableName, whereClause: whereClause) { tables in
            
           completion(tables)
        }
    }
    
    func bookedTablesFor(date: String, completion: @escaping ([[String: Any]]?) -> Void) {
        
        let whereClause = "Booking_Date = \(date)"
        database.select(tableName: tableName, whereClause: whereClause) { result in
            completion(result)
        }
    }
    
    func getAllTables(completion: String) {
        
        database.select(tableName: "Table_Reservations") { resultData in
            
//            print(resultData)
        }
    }
}
