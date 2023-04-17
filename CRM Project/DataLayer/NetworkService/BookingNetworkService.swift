//
//  ReservationNetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 23/02/23.
//

import Foundation

class BookingNetworkService {
    
    let networkService = NetworkService()
    
    func getBookedTables(date: String, time: String?,
                         completion: @escaping ([String: Any]?, Error?) -> Void) -> Void {
        
        let urlRequestString = "crm/v3/coql"
        
        var query = "select  Booking_Table.id, Booking_Table.Seating_Capacity from Reservations where Booking_Date = '\(date)'"
        
        if let time = time {
            query.append("and Pick_List_1 ='\(time)'")
        }
        
        let parameters = [
            "select_query" : query
        ]
        
        networkService.performNetworkCall(url: urlRequestString, method: .POST, urlComponents: nil, parameters: parameters, headers: nil) { data, error in
            
            completion(data, error)
        }
    }
    
    func getAllTables(completion: @escaping ([String: Any]?, Error?) -> Void) -> Void {
        
        let urlRequestString = "crm/v3/coql"
        
        let parameters = [
            "select_query" : "select Name, Seating_Capacity, Table_Location from Table_Reservations where Name is not null"
        ]
        
        networkService.performNetworkCall(url: urlRequestString, method: .POST, urlComponents: nil, parameters: parameters, headers: nil) { data, error in
          
            completion(data, error)
            
        }
    }

    func sendConformationMail(recordInfo: [String: Any?]) {
        
        guard let recieverEmail = recordInfo["Email"] as? String ,
              let recieverName = recordInfo["Name"] as? String,
              let tableBookingDate = recordInfo["Booking_Date"] as? String,
              let bookingTime = recordInfo["Pick_List_1"] as? String,
              let id = recordInfo["id"] as? String else {
            
            print("Invalid table data to send mail")
            return
        }
        
        let urlRequestString = "crm/v3/Reservations/\(id)/actions/send_mail"
        
        let fromAddress = [
                "user_name": "Guhan",
                "email": "guhan.saravanan@zohocorp.com"
        ]

        let toAddress = [
            [
                "user_name": recieverName,
                "email": recieverEmail
            ]
        ]
//
        let subject = "Regarding Table  Booking"
        //
        let content = "Hi \(recieverName) \n Table Booked Succesfully for date \(tableBookingDate) and for Time \(bookingTime)"
        
        let parameters = [
            "data": [
                [
                    "from" : fromAddress,
                    "to": toAddress,
                    "subject": subject,
                    "content": content
                ]
            ]
        ]
        
        networkService.performNetworkCall(url: urlRequestString, method: .POST, urlComponents: nil, parameters: parameters, headers: nil) { resultData, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }

            print(resultData!)
        }

    }
}

extension BookingNetworkService {
    
    func getAssociatedRerservations(tableId: String, completion: @escaping ([String: Any]?, Error?) -> Void) -> Void {
        
        let urlRequestString = "crm/v3/coql"
        var query = "select  id from Reservations where Booking_Table.id = '\(tableId)'"
        
        let parameters = [
            "select_query" : query
        ]
        
        networkService.performNetworkCall(url: urlRequestString, method: .POST, urlComponents: nil, parameters: parameters, headers: nil) { data, error in
            
            completion(data, error)
        }
    }
}
