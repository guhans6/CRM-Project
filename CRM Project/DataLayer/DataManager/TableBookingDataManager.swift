//
//  TableBookingDataManager.swift
//  CRM C
//
//  Created by guhan-pt6208 on 11/03/23.
//

import Foundation

class TableBookingDataManager {
    
    private let bookingDatabaseService = BookingDatabaseService()
    private let bookingNetworkService = BookingNetworkService()
    
    func getBookedTablesFor(date: String,
                            time: String?,
                            completion: @escaping ([[Table]], [String]) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        
        var bookedTableIds = [String]()
        var reservationIds = [String]()
        var allTables = [Table]()
        var bookedTables = [Table]()
        var availabeTables = [Table]()
        
        dispatchGroup.enter()
        getAllTables { tables in
            allTables = tables
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        bookingNetworkService.getBookedTables(date: date, time: time) { data, error in
            
            if let error = error as? NetworkError {
                
                if error == .emptyDataError {
                    dispatchGroup.leave()
                }
                print(error)
            }
            
            if let data = data,
               let data = data["data"] as? [[String: Any]] {
                
                data.forEach { table in
                    guard let bookingTableId = table["Booking_Table.id"] as? String,
                          let reservationId = table["id"] as? String else {
                        
                        print("Booking_Table.id not present")
                        return
                    }
                    
                    bookedTableIds.append(bookingTableId)
                    reservationIds.append(reservationId)
                }
                dispatchGroup.leave()
            }
        }
        
        // Wait for both data to arrive
        dispatchGroup.notify(queue: .global()) {
            
            allTables.forEach { table in
                
                if bookedTableIds.contains(table.id) {
                    bookedTables.append(table)
                } else {
                    availabeTables.append(table)
                }
            }
            
            completion([availabeTables, bookedTables], reservationIds)
        }
        
        bookingDatabaseService.bookedTablesFor(date: date) { results in

            guard let results = results else {

                print("DB returned nothing")
                return
            }

            for result in results {


            }
        }
    }
    
    func getAvailableTables(date: String, time: String?) {
        
        var bookedTables = [Table]()
        
        bookingDatabaseService.getAvailableTables(date: date, time: time) { [weak self] tables in
            
            guard let tables = tables else {
                
//                print("No tables in database")
                return
            }
            
            for table in tables {
                
                guard let table = self?.convertTables(data: table) else {

                    print("Can't convert tableDictionary")
                    return
                }
                
                bookedTables.append(table)
            }
        }
    }
    
    func getAllTables(completion: @escaping ([Table]) -> Void) -> Void {
        
        bookingNetworkService.getAllTables { data, error in
            
            if let error = error {
                print(error.localizedDescription, "in AllTables")
                return
            }
            
            var tables = [Table]()
            
            guard let data = data,
                  let data = data["data"] as? [[String: Any]]
            else {
                
                print("All table data is nil")
                return
            }
            
            
            data.forEach { datum in
                
                guard let table = self.convertTables(data: datum) else {

                    print("Can't convert tableDictionary")
                    return
                }
                
                tables.append(table)
            }
            completion(tables)
        }
    }
    
    private func convertTables(data: [String: Any]) -> Table? {
        
        guard let id = data["id"] as? String,
              let name = data["Name"] as? String,
              let seatingCapacity = data["Seating_Capacity"] as? String,
              let tableLocation = data["Table_Location"] as? String else {
            
            print("Table can't be parsed")
            return nil
        }
        let convertedTable = Table(id: id, name: name, seatingCapacity: seatingCapacity, tableLocation: tableLocation)
        return convertedTable
    }
    
}
