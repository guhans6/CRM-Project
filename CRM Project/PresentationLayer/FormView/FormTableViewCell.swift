//
//  FormTableViewCell.swift
//  FormPractice
//
//  Created by guhan-pt6208 on 06/02/23.
//

import UIKit

class FormTableViewCell: UITableViewCell {

    static let cellIdentifier = "formCell"
    let label = UILabel()
    lazy var textField = FormTextField()
    lazy var lookupButton = UIButton()
    lazy var switchButton = UISwitch()
    var fieldType: String!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabel() {
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -10)
        ])
    }
    
    func setUpCellWith(fieldName: String) {
        label.text = fieldName
    }
    
    func setLookupName(lookupApiName: String) { }
    
    func getFieldData(for type: String) -> (String, Any?) {
        
        if textField.text! == "" {
            return (label.text!, nil)
        }
        
        switch type {
        case "String":
            return (label.text!, textField.text)
        case "integer":
            let value = Int(textField.text!)
            return (label.text!, value)
        case "double":
            let value = Double(textField.text!)
            return (label.text!, value)
        case "boolean":
            var value = false
            if switchButton.isOn {
                value = true
            }
            return (label.text!, value)
        default:
            return (label.text!, textField.text)
        }
    }
}
