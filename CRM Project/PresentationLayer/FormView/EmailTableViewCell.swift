//
//  EmailTableViewCell.swift
//  FormPractice
//
//  Created by guhan-pt6208 on 12/02/23.
//

import UIKit

class EmailTableViewCell: FormTableViewCell {

    static let emailCellIdentifier = "EmailCell"
    
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
        textField.keyboardType = .emailAddress
        
        textField.addTarget(self, action: #selector(editingBegins), for: .editingDidBegin)
    }
    
    @objc private func editingBegins() {
        textField.placeholder = ""
    }
    
    override func getFieldData(for type: String) -> (String, Any?) {
        
        let emailRegex = "^[\\+\\-\\p{L}\\p{M}\\p{N}_]([\\p{L}\\p{M}\\p{N}!#$%&'*+\\-\\/=?^_`{|}~.]*)@(?=.{4,256}$)(([\\p{L}\\p{N}\\p{M}]+)(([\\-_]*[\\p{L}\\p{M}\\p{N}])*)[.])+[\\p{L}\\p{M}]{2,22}$"
        
        let email = textField.text
        if let _ = email?.range(of: emailRegex, options: .regularExpression) {
            
            self.invalidLabel.removeFromSuperview()
            return (label.text! , email)
        } else {
            
            configureInvalidLabel(with: "Invalid Email")
        }
        return (label.text! ,"")
    }
}
