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
//            "select_query" : "select  Booking_Table.id from Reservations where Booking_Date = '\(date)' and Pick_List_1 = 'Breakfast '"
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
        networkService.performNetworkCall(url: urlRequestString, method: .POST, urlComponents: nil, parameters: parameters, headers: nil) {data in
            
            let data = data["data"] as! [[String: Any]]
            
            data.forEach { table in
                bookedTableIds.append(table["Booking_Table.id"] as! String)
            }
            dispatchGroup.leave()
        } failure: { error in
            print(error)
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            
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
        
        networkService.performNetworkCall(url: urlRequestString, method: .POST, urlComponents: nil, parameters: parameters, headers: nil) { data in
          
//            let json = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
//
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .iso8601
//
//            let result = try? decoder.decode(TableData.self, from: json)
//
//            result?.data.forEach({ table in
//                print(table.name, table.seatingCapacity, table.id)
//            })
//            print(data)
            var tables = [Table]()
            let data = data["data"] as! [[String: Any]]
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
            
        } failure: { error in
            print(error, "aa")
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
        
        let json = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        print(String(data: json!, encoding: .utf8) ?? "asfasdf", "aaaaaaaa")
        networkService.performNetworkCall(url: urlRequestString, method: .POST, urlComponents: nil, parameters: parameters, headers: nil) { resultData in

            print(resultData)
        } failure: { error in
            print(error, "aaa")
        }

    }
}
