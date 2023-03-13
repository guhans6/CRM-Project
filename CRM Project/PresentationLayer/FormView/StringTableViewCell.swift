//
//  StringTableViewCell.swift
//  FormPractice
//
//  Created by guhan-pt6208 on 10/02/23.
//

import UIKit

class StringTableViewCell: FormTableViewCell {

    static let stringCellIdentifier = "StringCell"
    
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
        formTextField.keyboardType = .default
    }
    
    override func getFieldData(for type: String) -> (Any?, Bool) {
        
        if formTextField.text?.count ?? 0 > 255 {
            
            configureInvalidLabel(with: "Max Charactar Limit: 255")
            return (nil, false)
        } else if isMandatory && formTextField.text == "" {
            
            configureInvalidLabel(with: "Mandatory Field")
            return (nil, false)
        }
        
        return (formTextField.text, true)
    }
}
