//
//  DoubleTableViewCell.swift
//  FormPractice
//
//  Created by guhan-pt6208 on 12/02/23.
//

import UIKit

class DoubleTableViewCell: FormTableViewCell {

    static let doubleCellIdentifier = "DoubleCell"
    
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
        formTextField.returnKeyType = .done
        formTextField.keyboardType = .decimalPad
    }
    
    override func setRecordData(for data: Any, isEditable: Bool = true) {
        
        if let data = data as? Double {
            self.formTextField.text = String(data)
        } else {
            
            self.formTextField.text = data as? String
        }
//        formTextField.isUserInteractionEnabled = isEditable
        configureIsCellEditable(isEditable)
        
        let lookupData = getFieldData(for: fieldType)
        delegate?.textFieldData(data: lookupData.0, isValid: lookupData.1, index: index)
    }
    
    override func getFieldData(for type: String) -> (Any?, Bool) {
        
        let value = Double(formTextField.text!)
        
        return (value, true)
    }
}
