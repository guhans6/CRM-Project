//
//  EventDataManager.swift
//  CRM C
//
//  Created by guhan-pt6208 on 13/03/23.
//

import Foundation

class EventDataManager {
    
    let eventBookingNetworkService = EventBookingNetworkService()
    
    func getEventForData(date: String, completion: @escaping ([Event]) -> Void) -> Void {
        
        var bookedEvents = [Event]()
        eventBookingNetworkService.getEventsForDate(date: date) { events, error in
            
            
            if let error = error {
                
                if let error = error as? NetworkError, error == .emptyDataError {
                    
                    completion(bookedEvents)
                } else {
                    
                    print(error.localizedDescription, "In eventManger")
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
                
                let eventType = event["Event_Type"] as? String
                let hall = event["Hall"] as? String
                bookedEvents.append(Event(id: id, name: name, eventHall: hall, eventType: eventType))
            }
            completion(bookedEvents)
        }
    }
}
