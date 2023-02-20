//
//  RecordsNetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class RecordsNetworkService {
    
    let networService = NetworkService()
    
    func addRecord(module: String, recordData: [String: Any?], isAUpdate: Bool, recordId: String?) {
        
        let urlRequestString = "crm/v3/\(module)"
        
        
        var data = recordData
        var httpMethod = HTTPMethod.POST
        
        if isAUpdate {
            guard let recordId = recordId else { print("recordId Invalid"); return }
            
            data["id"] = recordId
            httpMethod =  HTTPMethod.PUT
        }
        
        let parameters = ["data": [data]]
        
        
        networService.performNetworkCall(url: urlRequestString, method: httpMethod, urlComponents: nil, parameters: parameters, headers: nil) { resultData in
            print(resultData)
        } failure: { error in
            print(error)
        }
    }
    
    func getRecords(module: String, id: String?, completion: @escaping ([Any]) -> Void) -> Void {
        
        var urlRequestString = "crm/v3/\(module)"
        
        
        if let ids = id {
            urlRequestString.append("/")
            urlRequestString.append(ids)
        } else {
            urlRequestString.append("?fields=Name,Email")
        }
        
        networService.performNetworkCall(url: urlRequestString, method: HTTPMethod.GET, urlComponents: nil, parameters: nil, headers: nil) { data in
            
            let recordsResult = data["data"] as! [Any]
            completion(recordsResult)
        } failure: { error in
            print(error)
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
}
