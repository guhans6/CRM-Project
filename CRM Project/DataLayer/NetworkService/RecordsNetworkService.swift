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
        var isIndividualFetch = false
        
        
        if let ids = id {
            isIndividualFetch = true
            urlRequestString.append("/")
            urlRequestString.append(ids)
        } else {
            urlRequestString.append("?fields=Name,Email")
        }
        
        networService.performNetworkCall(url: urlRequestString, method: HTTPMethod.GET, urlComponents: nil, parameters: nil, headers: nil) { data in
            
//            print(data)
            
            let recordsResult = data["data"] as! [Any]
//            var records = [Record]()
//            
//            recordsResult.forEach { record in
//                
//                let record = record as! [String: Any]
//                var secondaryData = ""
//                
//                if module == "Employee" {
//                    secondaryData = record["Email"] as? String ?? ""
//                }
//                let recordName = record["Name"] as! String
//                let recordId = record["id"] as! String
//                records.append(Record(recordName: recordName, secondaryRecordData: secondaryData, recordId: recordId))
//            }
            if isIndividualFetch {
                
            }
            
            completion(recordsResult)
        } failure: { error in
            print(error)
        }
    }
    
    private func getIndividualRecord(recordsData: [Any]) {
        
        let records = recordsData[0] as! [String: Any]
        
        var recordInfo = [(String, String)]()
//        let recordEn = 
        let name = "Name"
        let owner = "Owner"
        
        records.forEach { key, value in
            print(key, value)
            if !key.starts(with: "$") {
                
                if let recordDictionary = value as? [String: Any] {
                    let name = recordDictionary["name"] as! String
                    recordInfo.append((key, name))
                    
                } else if key == name || key == owner {
                    recordInfo.append(("Employee \(key)", value as! String))
                    
                } else if let value = value as? Bool {
                    print(value)
                    recordInfo.append((key, value == true ? "true" : "false"))
                    
                } else {
                    recordInfo.append((key, value as? String ?? ""))
                }
//                    recordInfo.append((key, editedInfo))
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
}
