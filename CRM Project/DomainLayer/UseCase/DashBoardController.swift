//
//  DashBoardController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 14/04/23.
//

import Foundation

class DashBoardController {
    
    private let dashBoardNetworkService = DashBoardNetworkService()
    
    func getStats(for option: DashBoardDetailOption, completion: @escaping ((tableCount: String, eventCount: String)) -> Void) -> Void {
        
        DispatchQueue.global().async { [weak self] in
            
            guard let dates = self?.getDatesFor(option) else {
                print("no dates")
                return
            }
            
            if dates.start == "" {
                return
            }
             
            self?.dashBoardNetworkService.getStats(fromDate: dates.start, toDate: dates.end) { count, error in
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let count = count else {
                    print("Count error")
                    return
                }
                
                DispatchQueue.main.async {
                    completion((tableCount: count.0, eventCount: count.1))
                }
                
            }
        }
    }
    
    private func getDatesFor(_ option: DashBoardDetailOption) -> (start: String, end: String) {
        
        switch option {
        
        case .weekly:
            
            let calendar = Calendar.current
            let today = Date()
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek!)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDateString = dateFormatter.string(from: startOfWeek!)
            let endDateString = dateFormatter.string(from: endOfWeek!)
            return (startDateString, endDateString)
        case .monthly:
            let calendar = Calendar.current
            let currentDate = Date()

            // Get the start date of the current month
            let startOfMonth = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: calendar.startOfDay(for: currentDate)))!

            // Get the end date of the current month
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDateString = dateFormatter.string(from: startOfMonth)
            let endDateString = dateFormatter.string(from: endOfMonth)
            return (startDateString, endDateString)
        case .yearly:
            
            let calendar = Calendar.current
            let currentDate = Date()

            let startOfYear = calendar.date(from: DateComponents(year: calendar.component(.year, from: currentDate)))!

            let endOfYear = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: startOfYear)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDateString = dateFormatter.string(from: startOfYear)
            let endDateString = dateFormatter.string(from: endOfYear)
            return (startDateString, endDateString)
        default:
            return ("", "")
        }
    }
}
