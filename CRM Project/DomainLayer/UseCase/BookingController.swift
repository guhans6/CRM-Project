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
    
    func getAvailableTablesFor(date: Date, time: String?, completion: @escaping ([[Table]]) -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = DateFormatter.formattedString(from: date, format: "yyyy-MM-dd")
        
        bookingService.getBookedTablesfor(date: formattedDate, time: time) { tables in
            
            completion(tables)
        }
    }
    
    func getAllTimings(completion: @escaping ([(String, String)]) -> Void ) -> Void {
        
        
//        fieldsController.getfields(module: "Reservations") { fields in
//
//            var timings = [(String, String)]()
//            
//            for field in fields {
//                if field.apiName == "Pick_List_1" {
//                    field.pickListValues.forEach { pickListValue in
//                        timings.append((pickListValue.displayValue, pickListValue.id))
//                    }
//                    completion(timings)
//                    break
//                }
//            }
//        }
    }
    
    func sendMailToCustomer(info: [String: Any?]) {
        
        BookingNetworkService().sendConformationMail(recordInfo: info)
    }
}

extension DateFormatter {
    static func formattedString(from date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
