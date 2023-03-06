//
//  RecordsNetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class RecordsNetworkService {
    
    let networService = NetworkService()
    
    static let cache = NSCache<NSString, NSDictionary>()
    
    private let tableName = "Records"
    
    func addRecord(module: String, recordData: [String: Any?], isAUpdate: Bool, recordId: String?) {
        
        let urlRequestString = "crm/v3/\(module)"
        
        
        var data = recordData
        var httpMethod = HTTPMethod.POST
        
        
        // MARK: DIFFERENT METHOD FOR UPDATE ONLY UPDATED RECORDS SHOULD BE SENT TO SERVER
        if isAUpdate {
            guard let recordId = recordId else { print("recordId Invalid"); return }
            
            data["id"] = recordId
            httpMethod =  HTTPMethod.PUT
        }
        
        let parameters = ["data": [data]]
        print(parameters)
        
        networService.performNetworkCall(url: urlRequestString, method: httpMethod, urlComponents: nil, parameters: parameters, headers: nil) { resultData in
//            print(resultData)
        } failure: { error in
            print(error)
        }
    }
    
    func getRecords(module: String, id: String?, completion: @escaping ([[String: Any]]) -> Void) -> Void {
        
        var urlRequestString = "crm/v3/\(module)"
        
        
        if let id = id {
            urlRequestString.append("/")
            urlRequestString.append(id)
        } else {
            urlRequestString.append("?fields=Name,Email")
        }
        
        networService.performNetworkCall(url: urlRequestString, method: HTTPMethod.GET, urlComponents: nil, parameters: nil, headers: nil) { data in
            
            let recordsResult = data["data"] as! [[String: Any]]

            completion(recordsResult)
//            self.saveAllRecordsInDatabase(records: recordsArray)
        } failure: { error in
//            let error = error as NSError
//            if error.code == 3840 {
//                completion([[String : Any]]())
//            } else {
//                print(error)
//            }
            print(error)
            
        }
    }
    
    func getAllRecordsFromDataBase(module: String, completion: @escaping ([[String: Any]]) -> Void) -> Void {
        
        let result = Database.shared.select(tableName: tableName, whereClause: "module = '\(module)'")
        
        guard let result = result else {
            print("No records in database")
            return
        }
        completion(result)
    }
    
    func getIndividualRecord(module: String, id: String?,
                             completion: @escaping ([String: Any]) -> Void) -> Void {
        
        var urlRequestString = "crm/v3/\(module)"
        
        guard let id = id else {
            print("Id not present to fetch record.")
            return
        }
        
        urlRequestString.append("/")
        urlRequestString.append(id)
        
        if let cachedRecord = RecordsNetworkService.cache.object(forKey: urlRequestString as NSString),
           let cachedRecord = cachedRecord as? [String: Any]  {
            
            print("from cache") 
            completion(cachedRecord)
        } else {
            networService.performNetworkCall(url: urlRequestString, method: HTTPMethod.GET, urlComponents: nil, parameters: nil, headers: nil) { data in
                
                
                // MARK: REPETION CHECK ABOVE FUNCTIONS
                let recordsResult = data["data"] as! [Any]
                let record = recordsResult[0] as! [String: Any]
                
                
                recordsResult.forEach { anything in
                    //                let tis = anything as! [Any]
                }
                RecordsNetworkService.cache.setObject(record as NSDictionary, forKey: urlRequestString as NSString)
                completion(record)
            } failure: { error in
                print(error.localizedDescription)
            }
        }
    }
    
    
    func deleteRecords(module: String, ids: [String], completion: @escaping ([Any]) -> Void) -> Void {
        var urlRequestString = "crm/v3/\(module)?ids="
        
        ids.forEach { id in
//            urlRequestString = urlRequestString + id + ","
            urlRequestString.append(id)
            urlRequestString.append(",")
        }
        
        networService.performNetworkCall(url: urlRequestString, method: HTTPMethod.DELETE, urlComponents: nil, parameters: nil, headers: nil) { data in
            
            // MARK: SHOULD DO SOMETHING ABOUT SUCCESSFUL DELETION
            let recordsResult = data["data"] as! [Any]
            recordsResult.forEach { record in
                let data = record as! [String: Any]
                print(data["status"] as! String)
            }
        } failure: { error in
            print(error)
        }
    }
    
    deinit {
        
    }
}
