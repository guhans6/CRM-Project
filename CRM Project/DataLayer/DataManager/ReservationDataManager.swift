//
//  ReservationDataManager.swift
//  CRM C
//
//  Created by guhan-pt6208 on 10/04/23.
//

import Foundation

class ReservationDataManager {
    
    let reservationNetworkService = ReservationNetworkService()
    
    func getReservationsForDate(date: String, completion: @escaping ([Reservation]) -> Void) -> Void {
        
        var reservations = [Reservation]()
        reservationNetworkService.getReservationsForDate(date: date) { events, error in
            
            
            if let error = error {
                
                if let error = error as? NetworkError, error == .emptyDataError {
                    
                    completion(reservations)
                } else {
                    
                    print(error.localizedDescription, "In reservationManager")
                }
                
                return
            }
            
            guard let events = events else {
                
                print("events is nil")
                return
            }
            
            for event in events {
                
                guard let id = event["id"] as? String,
                      let name = event["Name"] as? String else {
                          
                        print("event data parse error")
                        return
                      }
                
                let bookingTime = event["Pick_List_1"] as? String
                let bookingTable = event["Booking_Table.Name"] as? String
                reservations.append(Reservation(id: id, name: name, bookingTime: bookingTime, bookingTable: bookingTable))
//                bookedEvents.append(Event(id: id, name: name, eventHall: hall, eventType: eventType))
            }
            completion(reservations)
        }
    }
}
