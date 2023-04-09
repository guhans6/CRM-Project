//
//  IntegerTableViewCell.swift
//  FormPractice
//
//  Created by guhan-pt6208 on 12/02/23.
//

import UIKit

class IntegerTableViewCell: FormTableViewCell {

    static let integerCellIdentifier = "IntegerCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLabel()
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureTextField() {
        
        super.configureTextField()
        formTextField.keyboardType = .numberPad
    }
    
    override func setRecordData(for data: Any, isEditable: Bool = true) {
        
        if let data = data as? Int {
            self.formTextField.text = String(data)
        } else {
            self.formTextField.text = data as? String
        }
        
        saveLookupValue()
//        formTextField.isUserInteractionEnabled = isEditable
        configureIsCellEditable(isEditable)
    }
    
    private func saveLookupValue() {
        
        let lookupData = getFieldData(for: fieldType)
        delegate?.textFieldData(data: lookupData.0, isValid: lookupData.1, index: index)
    }
    
    override func getFieldData(for type: String) -> (Any?, Bool) {
        
        if type == "phone" {
            
            let phoneNumberRegex = "^([\\+]?)(?![\\.-])(?>(?>[\\.-]?[ ]?[\\da-zA-Z]+)+|([ ]?\\((?![\\.-])(?>[ \\.-]?[\\da-zA-Z]+)+\\)(?![\\.])([ -]?[\\da-zA-Z]+)?)+)+(?>(?>([,]+)?[;]?[\\da-zA-Z]+)+)?[;]?$"
            
            let phoneNumber = formTextField.text
            
            if let _ = phoneNumber?.range(of: phoneNumberRegex, options: .regularExpression){
                
                return(phoneNumber, true)
            } else if let phoneNumber = phoneNumber, phoneNumber == "" {
                return (phoneNumber, true)
            } else {
                
                configureInvalidLabel(with: "Invalid Number")
                return(phoneNumber, false)
            }
        }
        
        let fieldData = formTextField.text
        
        if fieldData?.count ?? 0 > 30 {
            
            configureInvalidLabel(with: "Max numbers count: 30")
            return ("", false)
        }
        let value = Int(formTextField.text!)
        return (value, true)
    }
}
