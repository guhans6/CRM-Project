//
//  RecordController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 16/02/23.
//

import Foundation


class RecordController {
    
    func addRecord(module: String, recordData: [String: Any?], isAUpdate: Bool, recordId: String?) {

        
        var data = recordData
        var httpMethod = HTTPMethod.POST.rawValue
        
        if isAUpdate {
            guard let recordId = recordId else { print("recordId Invalid"); return }
            
            data["id"] = recordId
            httpMethod =  HTTPMethod.PUT.rawValue
        }
        
        let parameter = ["data": [data]]
        
        


//        networkManager.performDataTask(url: requestURL, method: httpMethod, urlComponents: nil, parameters: parameter, headers: headers, accessToken: accessToken) { data, error in
//
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//
//            guard let result = data else {
//                print("No data received")
//                return
//            }
//
//            print(result)
//
//        }
    }
}
