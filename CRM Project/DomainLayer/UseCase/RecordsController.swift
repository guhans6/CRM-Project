//
//  RecordsController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 16/02/23.
//

import Foundation

class RecordsController {
    
    private let recordsNetworkService = RecordsNetworkService()
    private let recordsDataManager = RecordsDataManager()
    private let fieldsController = FieldsDataManager()
    
    func addRecord(module: String,
                   recordData: [String: Any?],
                   isAUpdate: Bool,
                   recordId: String?,
                   isRecordSaved: @escaping (Bool) -> Void) {
 
        DispatchQueue.global().async {
            self.recordsDataManager.addRecord(module: module, recordData: recordData, isAUpdate: isAUpdate, recordId: recordId) { result in
                
                DispatchQueue.main.async {
                    isRecordSaved(result)
                }
            }
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
        
        DispatchQueue.global().async {
            self.recordsDataManager.getRecords(module: module) { records in
                
                DispatchQueue.main.async {
                    completion(records)
                }
            }
        }
    }
    
    func getIndividualRecords(module: String, id: String,
                              completion: @escaping ([(String, Any)]) -> Void) -> Void {

        DispatchQueue.global().async {
            
            self.fieldsController.getfieldMetaData(module: module) { fields in
                
                if fields.isEmpty == false {
                    self.recordsDataManager.getRecordById(module: module, id: id, fields: fields) { recordInfo in
                        
                        DispatchQueue.main.async {
                            
                            completion(recordInfo)
                        }
                    }
                }
            }
            
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
    
    func deleteRecords(module: String, ids: [String], completion: @escaping (Bool) -> Void) -> Void {
        
        DispatchQueue.global().async {
            self.recordsDataManager.deleteRecords(module: module, ids: ids) { data in
                
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        }
    }
    
    func sortRecords(records: [Record], sortMethod: String, completion: ([String: [Record]], [String]) -> Void) -> Void {
        
        var sortedRecords = [Record]()
        if sortMethod == "ASC" {
            sortedRecords = records.sorted {
                $0.recordName < $1.recordName
            }
        } else {
            
            sortedRecords = records.sorted {
                $0.recordName > $1.recordName
            }
        }
        
        var sectionData: [String: [Record]] = [:]

        for record in sortedRecords {
            
            let firstLetter = String(record.recordName.prefix(1).uppercased())
            
            if sectionData[firstLetter] != nil {
                sectionData[firstLetter]?.append(record)
            } else {
                sectionData[firstLetter] = [record]
            }
        }
        var sectionTitles = [String]()
        if sortMethod == "ASC" {
            sectionTitles = sectionData.keys.sorted()
        } else {
            sectionTitles = sectionData.keys.sorted {
                $0 > $1
            }
        }

        completion(sectionData, sectionTitles)
    }
}
