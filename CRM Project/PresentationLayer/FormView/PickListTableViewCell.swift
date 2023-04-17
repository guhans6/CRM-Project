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
    
    
    
    override func getFieldData(for type: String) -> (Any?, Bool) {
        
        if !isMultiSelect {
            
            return (pickListValues.first, true)
        } else {
            return(pickListValues, true)
        }
    }
    
    override func setRecordData(for data: Any, isEditable isRecordEditing: Bool = true) {
        
        self.formTextField.text = data as? String
        self.pickListValues = self.formTextField.text!.components(separatedBy: ",")

        configureIsCellEditable(isRecordEditing)
        savePickListValue()
    }
    
    private func savePickListValue() {
        
        let pickListData = getFieldData(for: "")
        
        delegate?.textFieldData(data: pickListData.0, isValid: pickListData.1, index: index)
    }
}

extension PickListTableViewCell {
    
    func getPickListValues() -> [String] {
        
        return pickListValues
    }
}

extension PickListTableViewCell: PickListDelegate {
    
    func getPickListValues(isMultiSelect: Bool, pickListValue: [String]) {
        
        self.formTextField.text = pickListValue.joined(separator: ", ")
        pickListValues = pickListValue
        self.isMultiSelect = isMultiSelect
        
        savePickListValue()
    }

}
