//
//  LookupTableViewDelegate.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 14/02/23.
//

import Foundation

protocol RecordTableViewDelegate {
    
    func setLookupRecordAndId(recordName: String,recordId: String)
}

protocol PickListDelegate {
    
    func getPickListValues(isMultiSelect: Bool, pickListValue: [String])
}
