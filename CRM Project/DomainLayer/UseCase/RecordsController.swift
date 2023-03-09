//
//  RecordsController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 16/02/23.
//

import Foundation

class RecordsController {
    
    let recordsNetworkService = RecordsNetworkService()
    let recordsDataManager = RecordsDataManager()
    
    
    func addRecord(module: String,
                   recordData: [String: Any?],
                   isAUpdate: Bool,
                   recordId: String?,
                   isRecordSaved: @escaping (Bool) -> Void) {
        
        recordsNetworkService.addRecord(module: module, recordData: recordData, isAUpdate: isAUpdate, recordId: recordId) { result in
            
            isRecordSaved(result)
        }
        
        switch module {
        case "Reservations":
            
            let bookingController = BookingController()
            bookingController.sendMailToCustomer(info: recordData)
        default:
            print("other module network call")
        }
    }
    
    func getAllRecordsFor(module: String, completion: @escaping ([Record]) -> Void) -> Void {
        
        recordsDataManager.getRecords(module: module, id: nil) { records in
            
            completion(records)
        }
    }
    
    func getIndividualRecords(module: String, id: String?, completion: @escaping ([(String, Any)]) -> Void) -> Void {
        
//        recordsNetworkService.getIndividualRecord(module: module, id: id) { recordInfo in
//
//
//            completion(recordInfo)
//        }
        recordsDataManager.getRecordById(module: module, id: id) { recordInfo in
            completion(recordInfo)
        }
    }
    
    private func convert(date: String) -> String {
        
        
        
        let regex = #"^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2]\d|3[0-1])$"# // your regex pattern
        
        if let _ = date.range(of: regex, options: .regularExpression) {
            
            //            print("Valid date string")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let date = dateFormatter.date(from: date) {
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let formattedDate = dateFormatter.string(from: date)
                
                return formattedDate
            } else {
                // the string is invalid
                print("Invalid date string")
            }
        }
        return date
    }
    
    func deleteRecords(module: String, ids: [String], completion: @escaping ([Any]) -> Void) -> Void {
        
        recordsNetworkService.deleteRecords(module: module, ids: ids) { data in
            completion(data)
        }
    }
}
