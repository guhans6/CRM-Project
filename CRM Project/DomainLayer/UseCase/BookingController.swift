//
//  BookingController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 23/02/23.
//

import Foundation

class BookingController {
    
    let bookingService = BookingNetworkService()
    lazy var fieldsController = FieldsController()
    
    func getAvailableTablesFor(date: Date, time: String?,
                               completion: @escaping ([[Table]], [String]) -> Void) {
        
        let formattedDate = DateFormatter.formattedString(from: date, format: "yyyy-MM-dd")
        
        bookingService.getBookedTablesfor(date: formattedDate,
                                          time: time) { tables, reservationIds in
            
            completion(tables, reservationIds)
        }
    }
    
    func sendMailToCustomer(info: [String: Any?]) {
        
        bookingService.sendConformationMail(recordInfo: info)
    }
}
