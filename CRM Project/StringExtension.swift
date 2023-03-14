//
//  StringExtension.swift
//  CRM C
//
//  Created by guhan-pt6208 on 14/03/23.
//

import Foundation

extension String {
    
    func localized() -> String {
        
        return NSLocalizedString(self, comment: self)
    }
}
