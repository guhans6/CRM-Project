//
//  DateFormatterExtension.swift
//  CRM C
//
//  Created by guhan-pt6208 on 09/03/23.
//

import Foundation

extension DateFormatter {
    
    static func formattedString(from date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
