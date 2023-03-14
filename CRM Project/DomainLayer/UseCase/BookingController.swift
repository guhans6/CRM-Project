//
//  BookingController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 23/02/23.
//

import Foundation

class BookingController {
    
    private let bookingService = BookingNetworkService()
    private let bookingDataManager = TableBookingDataManager()
    
    func getAvailableTablesFor(date: Date, time: String?,
                               completion: @escaping ([[Table]], [String]) -> Void) {
        
        let formattedDate = DateFormatter.formattedString(from: date, format: "yyyy-MM-dd")
        let formattedDate2 = DateFormatter.formattedString(from: date, format: "dd-MM-yyyy")
        
        bookingDataManager.getAvailableTables(date: formattedDate2, time: time)
        print(formattedDate)
        DispatchQueue.global().async {
            
            self.bookingDataManager.getBookedTablesFor(date: formattedDate, time: time)
            { tables, reservationIds in
                
                DispatchQueue.main.async {
                    completion(tables, reservationIds)
                }
            }
        }
        
    }
    
    func sendMailToCustomer(info: [String: Any?]) {
        
        bookingService.sendConformationMail(recordInfo: info)
    }
}
