//
//  PickListTableViewCell.swift
//  CRM C
//
//  Created by guhan-pt6208 on 21/02/23.
//

import UIKit

class PickListTableViewCell: LookupTableViewCell {
    
    
    static let pickListCellIdentifier = "pickListCell"
    private var pickListValues = [String]()
    
    override func getFieldData(for type: String) -> (String, Any?) {
        if pickListValues.count == 1 {
            
            return ("", pickListValues.first)
        } else {
            return("", pickListValues)
        }
    }
    
}

extension PickListTableViewCell: PickListDelegate {

    func getPickListValues(pickListId: String, pickListValue: [String]) {
        self.textField.text = pickListValue.joined(separator: ",")
        pickListValues = pickListValue
    }
}
