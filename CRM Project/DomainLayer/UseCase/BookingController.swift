//
//  BookingController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 23/02/23.
//

import Foundation

class BookingController {
    
    let bookingService = BookingNetworkService()
    let networkService = NetworkService()
    lazy var fieldsController = FieldsController()
    
    func getAvailableTablesFor(date: Date, completion: @escaping ([[Table]]) -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        
        bookingService.getBookedTablesfor(date: formattedDate) { tables in
            
            completion(tables)
        }
    }
    
    func getAllTimings(completion: ([(String, String)]) -> Void ) -> Void {
        
        
        fieldsController.getfields(module: "Reservations") { fields in
            var values = [(String, String)]()
            
            fields[4].pickListValues.forEach { pickListValue in
                values.append((pickListValue.displayValue, pickListValue.id))
            }
        }
    }
}
