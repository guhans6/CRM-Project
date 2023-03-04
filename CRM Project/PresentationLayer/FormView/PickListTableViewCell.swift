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
    
    override func setRecordData(for data: Any, isEditable isRecordEditing: Bool = true) {
        
        self.textView.text = data as? String
        self.isUserInteractionEnabled = isRecordEditing
    }
    
}

extension PickListTableViewCell: PickListDelegate {
    
    func getPickListValues(isMultiSelect: Bool, pickListValue: [String]) {
        self.textView.text = pickListValue.joined(separator: ", ")
        pickListValues = pickListValue
        self.isMultiSelect = isMultiSelect
    }

}
