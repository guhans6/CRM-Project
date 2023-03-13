//
//  EventBookingNetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 13/03/23.
//

import Foundation

class EventBookingNetworkService {
    
    private let networkService = NetworkService()
    
    func getEventsForDate(date: String, completion: @escaping ([[String: Any]]?,Error?) -> Void) -> Void {
        
        let urlRequestString = "crm/v3/coql"
        
        let query = "select  id, Name, Hall, Event_Type from Functions1 where 'From' <= '\(date)' and 'To' >= '\(date)' "
        
        let parameters = [
            "select_query" : query
        ]
        
        networkService.performNetworkCall(url: urlRequestString, method: .POST, urlComponents: nil, parameters: parameters, headers: nil) { resultData, error in
            
            
            if let error = error {
                    
                completion(nil, error)
                return
            }

            guard let data = resultData, let eventData = data["data"] as? [[String: Any]] else {
                print("Invalid modules data")
                return
            }
            
            completion(eventData, nil)
        }
    }
}
