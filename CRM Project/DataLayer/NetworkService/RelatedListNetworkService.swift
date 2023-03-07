//
//  RelatedListNetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 23/02/23.
//

import Foundation

class RelatedListNetworkService {
    
    private let networkService = NetworkService()
    
    func getRelatedList(module: String, completion: @escaping ([RelatedList]) -> Void ) -> Void {
        
        let urlRequestString = "crm/v3/settings/related_lists?module=\(module)"
        
        networkService.performNetworkCall(url: urlRequestString, method: .GET, urlComponents: nil, parameters: nil, headers: nil) { data, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("RelatedList is nil")
                return
            }
            
            let json = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let result = try decoder.decode([RelatedList].self, from: json)
                var relatedList = [RelatedList]()
                
                result.forEach { list in
                    
                    if list.type == .customLookup {
                        relatedList.append(list)
                    }
                }
                completion(relatedList)
            } catch {
                print(error)
            }
            
        }
    }
}
