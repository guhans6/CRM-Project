//
//  EventBookingController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 13/03/23.
//

import Foundation

class EventBookingController {
    
    private let eventDataManager = EventDataManager()
    
    func getEventsFor(date: Date, completion: @escaping ([Event]) -> Void) -> Void {
        
        let formattedDate = DateFormatter.formattedString(from: date, format: "yyyy-MM-dd")
        
        DispatchQueue.global().async {
            self.eventDataManager.getEventForData(date: formattedDate) { events in
                
                DispatchQueue.main.async {
                    completion(events)
                }
            }
        }
    }
}
