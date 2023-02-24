//
//  TableBookingViewPresenter.swift
//  CRM C
//
//  Created by guhan-pt6208 on 23/02/23.
//

import Foundation

class TableBookingViewPresenter {
    
    private let bookingController = BookingController()
    
    func getTablesIn(date: Date, completion: @escaping ([[Table]]) -> Void) -> Void {
        
        bookingController.getAvailableTablesFor(date: date) { allTables in
            
            completion(allTables)
        }
    }
    
}
