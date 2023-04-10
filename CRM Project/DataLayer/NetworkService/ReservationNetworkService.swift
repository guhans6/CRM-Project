//
//  ReservationNetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 10/04/23.
//

import Foundation

class ReservationNetworkService {
    
    private let networkService = NetworkService()
    
    func getReservationsForDate(date: String, completion: @escaping ([[String: Any]]?,Error?) -> Void) -> Void {
        
        let urlRequestString = "crm/v3/coql"
        
        let query =
        "select  id, Name, Email, Booking_Table.Name, Pick_List_1 from Reservations where Booking_Date = '\(date)' "
        
        let parameters = [
            "select_query" : query
        ]
        
        networkService.performNetworkCall(url: urlRequestString, method: .POST, urlComponents: nil, parameters: parameters, headers: nil) { resultData, error in
            
            
            if let error = error {
                    
                completion(nil, error)
                return
            }

            guard let data = resultData, let reservationData = data["data"] as? [[String: Any]] else {
                print("Invalid modules data")
                return
            }
            
            completion(reservationData, nil)
        }
    }
}
