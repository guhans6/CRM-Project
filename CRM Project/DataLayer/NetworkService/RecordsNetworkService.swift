//
//  RecordsNetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation
import UIKit

class RecordsNetworkService {
    
    private let networService = NetworkService()
    
    private static let cache = NSCache<NSString, NSDictionary>()
    
    private let tableName = "Records"
    
    func addRecord(module: String, recordData: [String: Any?], isAUpdate: Bool, recordId: String?, isSaved: @escaping(Bool) -> Void) -> Void {
        
        let urlRequestString = "crm/v3/\(module)"
        
        var recordImage: UIImage?
        var data = recordData
        var httpMethod = HTTPMethod.POST
        
        // MARK: DIFFERENT METHOD FOR UPDATE ONLY UPDATED RECORDS SHOULD BE SENT TO SERVER
        if isAUpdate {
            guard let recordId = recordId else { print("recordId Invalid"); return }
            
            data["id"] = recordId
            httpMethod =  HTTPMethod.PUT
        }
        
        if let image = data["Record_Image"] {
            data.removeValue(forKey: "Record_Image")
            recordImage = image as? UIImage
        }
        
        let parameters = ["data": [data]]
        
        networService.performNetworkCall(url: urlRequestString, method: httpMethod, urlComponents: nil, parameters: parameters, headers: nil) { resultData, error in
            
            if let error = error {
                print(error)
                isSaved(false)
                return
            } 
            
            if let resultData = resultData,
               let data = resultData["data"] as? [[String: Any]],
               data[0]["code"] as? String == "SUCCESS",
               let details = data[0]["details"] as? [String: Any],
               let recordIdFromResponse = details["id"] as? String
            {
                
                if let recordImage = recordImage {
                    
                    self.networService.uploadImage(photoData: recordImage,
                                                   module: module,
                                                   recordId: recordIdFromResponse)
                }
                
                isSaved(true)
                return
            } else {
                
                print(resultData as Any)
                isSaved(false)
                return
            }
        }
    }
    
    
    
    func getRecords(module: String, id: String?, completion: @escaping ([[String: Any]]?, Error?) -> Void) -> Void {
        
        var urlRequestString = "crm/v3/\(module)"
        
        
        if let id = id {
            urlRequestString.append("/")
            urlRequestString.append(id)
        } else {
            urlRequestString.append("?fields=Name,Email,Owner")
        }
        
        networService.performNetworkCall(url: urlRequestString, method: HTTPMethod.GET, urlComponents: nil, parameters: nil, headers: nil) { data, error in
            
            if let error = error {
                
                completion(nil, error)
                return
            }
            
            guard let data = data, let recordsResult = data["data"] as? [[String: Any]] else {
                
                print("get Records Data Error")
                return
            }
            
            completion(recordsResult, nil)
        }
    }
    
    func getRecordImage(module: String,
                        id: String,
                        completion: @escaping (UIImage?) -> Void) -> Void {
        
        let urlRequestString = "crm/v3/\(module)/\(id)/photo"
        
        networService.downloadImage(url: urlRequestString, module: module, recordId: id) { result in
            
            guard let result = result else {
                print("No image present")
                return
            }
            
            completion(UIImage(data: result))
        }
        
    }
    
    func getIndividualRecord(module: String, id: String,
                             completion: @escaping ([String: Any]) -> Void) -> Void {
        
        var urlRequestString = "crm/v3/\(module)"
        
        urlRequestString.append("/")
        urlRequestString.append(id)
        
        networService.performNetworkCall(url: urlRequestString, method: HTTPMethod.GET, urlComponents: nil, parameters: nil, headers: nil) { data, error in
            
            if let error = error {
                print(error.localizedDescription, "Individual get data Error")
                return
            }
            
            // MARK: REPETION CHECK ABOVE FUNCTIONS
            guard let data = data,
                  let recordsResult = data["data"] as? [Any],
                  let record = recordsResult[0] as? [String: Any] else {
                print("Individual get data Error")
                return
            }
            
            completion(record)
        }
        
    }
    
    
    func deleteRecords(module: String, ids: [String], completion: @escaping (Bool) -> Void) -> Void {
        var urlRequestString = "crm/v3/\(module)?ids="
        
        ids.forEach { id in
            //            urlRequestString = urlRequestString + id + ","
            urlRequestString.append(id)
            urlRequestString.append(",")
        }
        
        networService.performNetworkCall(url: urlRequestString, method: HTTPMethod.DELETE, urlComponents: nil, parameters: nil, headers: nil) { data, error in
            
            if let error = error {
                print(error.localizedDescription)
                print("Individual get data Error")
                return
            }
            
            // MARK: SHOULD DO SOMETHING ABOUT SUCCESSFUL DELETION
            guard let data = data,
                  let recordsResult = data["data"] as? [Any] else {
                print("Record deletion data error")
                return
            }
            
            if let status = recordsResult.first as? [String: Any],
               let statusCode = status["code"] as? String,
               statusCode == "SUCCESS" {
                
                completion(true)
            } else {
                completion(false)
            }
            
        }
    }
}
