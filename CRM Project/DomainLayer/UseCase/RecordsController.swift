//
//  RecordsController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 16/02/23.
//

import Foundation
import UIKit

class RecordsController {
    
    private let recordsDataManager = RecordsDataManager()
    private let fieldsController = FieldsDataManager()
    private lazy var bookingController = BookingController()
}

extension RecordsController: AddRecordContract {
    
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
            print("")
        }
    }
}

extension RecordsController: RecordsContract {
    
    func getAllRecordsFor(module: String, completion: @escaping ([Record]) -> Void) -> Void {
        
        DispatchQueue.global().async {
            self.recordsDataManager.getRecords(module: module) { records in
                
                DispatchQueue.main.async {
                    completion(records)
                }
            }
        }
    }
    
    func sortRecords(records: [Record],
                     sortMethod: String,
                     completion: ([String: [Record]], [String]) -> Void) -> Void {
        
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

extension RecordsController: RecordInfoContract {
    
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
    
    func deleteRecords(module: String, ids: [String], completion: @escaping (Bool) -> Void) -> Void {
        
        DispatchQueue.global().async {
            
            if module == "Table_Reservations" {
                
                guard let id = ids.first else {
                    print("no table id to delete reservations")
                    return
                }
                
                self.bookingController.getAssociatedReservationsFor(tableId: id) { [weak self] reservationIds in
                    
                    self?.recordsDataManager.deleteRecords(module: "Reservations",
                                                           ids: reservationIds)
                    { isSuccess in
                        
                        if !isSuccess {
                            print("Delete reservations Failiure")
                        } else {
                            print("all deletion success")
                            self?.recordsDataManager.deleteRecords(module: module, ids: ids) { data in
                                
                                DispatchQueue.main.async {
                                    completion(data)
                                }
                            }
                        }
                    }
                }
            } else {
            
                self.recordsDataManager.deleteRecords(module: module, ids: ids) { data in
                    
                    DispatchQueue.main.async {
                        completion(data)
                    }
                }
            }
        }
    }
}

extension RecordsController {
    
    func getRecordImage(module: String, recordId: String, completion: @escaping (UIImage?) -> Void) {
        
        DispatchQueue.global().async { [weak self] in
            
            self?.recordsDataManager.getRecordImage(module: module, recordId: recordId) { image in
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        
    }
}

extension RecordsController {
    
    func saveImage(image: UIImage?, module: String, recordId: String, completion: @escaping (Bool) -> Void) {
        
        recordsDataManager.uploadImage(image: image, module: module, recordId: recordId) { isSuccess in
            completion(isSuccess)
        }
    }
    
    func deleteImage(module: String, recordId: String, completion: @escaping (Bool) -> Void) {
        recordsDataManager.deleteImage(module: module, recordId: recordId) { isSuccess in
            
            completion(isSuccess)
        }
    }
}
