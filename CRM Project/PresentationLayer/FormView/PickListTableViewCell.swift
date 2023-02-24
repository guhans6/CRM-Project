//
//  PickListTableViewCell.swift
//  CRM C
//
//  Created by guhan-pt6208 on 21/02/23.
//

import UIKit

class PickListTableViewCell: LookupTableViewCell {
    
    
    static let pickListCellIdentifier = "pickListCell"
    private var isMultiSelect = false
    private var pickListValues = [String]()
    
    override func getFieldData(for type: String) -> (String, Any?) {
        if !isMultiSelect {
            
            return ("", pickListValues.first)
        } else {
            return("", pickListValues)
        }
    }
    
    
}

extension PickListTableViewCell: PickListDelegate {
    
    func getPickListValues(isMultiSelect: Bool, pickListValue: [String]) {
        self.textField.text = pickListValue.joined(separator: ", ")
        pickListValues = pickListValue
        self.isMultiSelect = isMultiSelect
    }

}
