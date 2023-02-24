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
    
    func getAvailableTablesFor(date: Date, completion: @escaping ([[Table]]) -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        
        bookingService.getBookedTablesfor(date: formattedDate) { tables in
            
//            tables.forEach { t in
//                print("1")
//                t.forEach { t in
//                    print(t.name)
//                }
//            }
            completion(tables)
        }
    }
}
