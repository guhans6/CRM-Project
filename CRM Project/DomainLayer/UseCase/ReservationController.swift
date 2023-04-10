//
//  ReservationController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 10/04/23.
//

import Foundation

class ReservationController {
    
    private let reservationDataManager = ReservationDataManager()
    
    func getReservationsFor(date: Date, completion: @escaping ([Reservation]) -> Void) -> Void {
        
        let formattedDate = DateFormatter.formattedString(from: date, format: "yyyy-MM-dd")
        
        DispatchQueue.global().async {
            self.reservationDataManager.getReservationsForDate(date: formattedDate) { reservations in
                
                DispatchQueue.main.async {
                    completion(reservations)
                }
            }
        }
    }
}
