//
//  ReservationNetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 23/02/23.
//

import Foundation

class BookingNetworkService {
    
    let networkService = NetworkService()
    
    func getBookedTablesfor(date: String, completion: @escaping ([[Table]]) -> Void) -> Void {
        
        let urlRequestString = "crm/v3/coql"
        let dispatchGroup = DispatchGroup()
        
        let parameters = [
            "select_query" : "select  Booking_Table.id from Reservations where Booking_Date = '\(date)'"
        ]
        
        var bookedTableIds = [String]()
        var allTables = [Table]()
        var bookedTables = [Table]()
        var availabeTables = [Table]()
        
        dispatchGroup.enter()
        getAllTables { tables in
            allTables = tables
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        networkService.performNetworkCall(url: urlRequestString, method: .POST, urlComponents: nil, parameters: parameters, headers: nil) {data, error in
            
            if let error = error as? NetworkError {
                
                if error == .emptyDataError {
                    dispatchGroup.leave()
                } else {
                    print(error)
                }
            }
            
            
            guard let data = data,
                  let data = data["data"] as? [[String: Any]]
            else {
                return
            }
            
            data.forEach { table in
                
                guard let bookingTableId = table["Booking_Table.id"] as? String else {
                    
                    print("Booking_Table.id not present")
                    return
                }
                bookedTableIds.append(bookingTableId)
            }
            dispatchGroup.leave()
        }
        
        
        // Wait for both data to arrive
        dispatchGroup.notify(queue: .main) {
            
            print(bookedTables)
            if bookedTableIds.isEmpty {
                
                completion([allTables, [Table]()])
                
            } else {
                
                allTables.forEach { table in
                    
                    if bookedTableIds.contains(table.id) {
                        bookedTables.append(table)
                    } else {
                        availabeTables.append(table)
                    }
                    completion([availabeTables, bookedTables])
                }
            }
        }
       
    }
    
    private func getAllTables(completion: @escaping ([Table]) -> Void) -> Void {
        
        let urlRequestString = "crm/v3/coql"
        
        let parameters = [
            "select_query" : "select Name, Seating_Capacity, Table_Location from Table_Reservations where Name is not null"
        ]
        
        networkService.performNetworkCall(url: urlRequestString, method: .POST, urlComponents: nil, parameters: parameters, headers: nil) { data, error in
          
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            var tables = [Table]()
            
            guard let data = data,
                  let data = data["data"] as? [[String: Any]]
            else {
                
                print("All table data is nil")
                return
            }
            data.forEach { d in
                
                guard let id = d["id"] as? String,
                      let name = d["Name"] as? String,
                      let seatingCapacity = d["Seating_Capacity"] as? String,
                      let tableLocation = d["Table_Location"] as? String else {
                    
                    print("Table can't be parsed")
                    return
                }
                
                tables.append(Table(id: id, name: name, seatingCapacity: seatingCapacity, tableLocation: tableLocation))
            }
//
            completion(tables)
            
        }
    }
    
    func sendConformationMail(recordInfo: [String: Any?]) {
        
        
        let urlRequestString = "crm/v3/Employee/5622594000000428318/actions/send_mail"
        
        guard let recieverEmail = recordInfo["Email"] as? String ,
              let recieverName = recordInfo["Name"] as? String,
              let tableBookingDate = recordInfo["Booking_Date"] as? String,
              let bookingTime = recordInfo["Pick_List_1"] as? String else {
            
            print("Invalid table data to send mail")
            return
        }
        print(recordInfo)
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
