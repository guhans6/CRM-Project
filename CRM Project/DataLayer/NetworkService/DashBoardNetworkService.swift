//
//  DashBoardNetworkService.swift
//  CRM C
//
//  Created by guhan-pt6208 on 14/04/23.
//

import Foundation

class DashBoardNetworkService {
    
    private let networkService = NetworkService()
    
    func getStats(fromDate: String, toDate: String, completion: @escaping ((String, String)?, Error?) -> Void) -> Void {
        
        let urlRequestString = "crm/v3/coql"
        
        let query =
        "select id from Reservations where Booking_Date >= '\(fromDate)' and Booking_Date <= '\(toDate)' "
        
        let parameters = [
            "select_query" : query
        ]
        
        networkService.performNetworkCall(url: urlRequestString,
                                          method: .POST,
                                          urlComponents: nil,
                                          parameters: parameters,
                                          headers: nil)
        { [weak self] resultData, error in
            
            
            if let error = error {
                    
                if let networkError = error as? NetworkError, networkError == .emptyDataError {
                    
                    self?.getEventStats(fromDate: fromDate, toDate: toDate) { eventCount in
                        
                        if let eventCount = eventCount {
                            completion(("0", eventCount), nil)
                        }
                    }
                } else {

                    completion(nil, error)
                }
                print(error)
                return
            }

            guard let data = resultData,
                  let info = data["info"] as? [String: Any],
                  let tablesCount = info["count"] as? Int else {
                print("Invalid count data")
                return
            }
            
            self?.getEventStats(fromDate: fromDate, toDate: toDate) { eventCount in
                
                if let eventCount = eventCount {
                    completion((String(tablesCount), eventCount), nil)
                }
            }
//            completion(info, nil)
        }
    }
    
    private func getEventStats(fromDate: String, toDate: String, completion: @escaping (String?) -> Void) -> Void {
        
        let urlRequestString = "crm/v3/coql"
        
        let query =
        "select  id from Functions1 where 'From' >= '\(fromDate)' and 'To' <= '\(toDate)' "
        
        let parameters = [
            "select_query" : query
        ]
        
        networkService.performNetworkCall(url: urlRequestString,
                                          method: .POST,
                                          urlComponents: nil,
                                          parameters: parameters,
                                          headers: nil)
        { resultData, error in
            
            if let error = error {
                
                if let networkError = error as? NetworkError, networkError == .emptyDataError {
                    completion("0")
                } else {
                    completion(nil)
                }
                return
            }

            guard let data = resultData,
                  let info = data["info"] as? [String: Any],
                  let count = info["count"] as? Int else {
                print("Invalid event count data")
                return
            }
            
            completion(String(count))
        }
    }
}
