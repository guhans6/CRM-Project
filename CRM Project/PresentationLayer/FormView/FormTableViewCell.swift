//
//  FormTableViewCell.swift
//  FormPractice
//
//  Created by guhan-pt6208 on 06/02/23.
//

import UIKit

class FormTableViewCell: UITableViewCell {

    static let cellIdentifier = "formCell"
    private let textField = FormTextField()
    private let label = UILabel()
    private let switchButton = UISwitch()
    private var fieldType: String!
    
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
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func configureTextField() {
        
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.autocorrectionType = .no
//        textField.keyboardType = .decimalPad
        textField.returnKeyType = .done
        textField.autocapitalizationType = .none
        
        NSLayoutConstraint.activate([
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureSwitch() {
        
        contentView.addSubview(switchButton)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            switchButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            switchButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            switchButton.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    func setField(fieldName: String, fieldType: String) {
        self.fieldType = fieldType
        label.text = fieldName
        
        if fieldType == "boolean" {
            configureSwitch()
        } else {
            if fieldName == "Email" {
                configureTextField()
                textField.keyboardType = .emailAddress
            } else {
                configureTextField()
                switch fieldType {
                case "String":
                    textField.keyboardType = .default
                case "integer":
                    textField.keyboardType = .numberPad
                case "double":
                    textField.keyboardType = .decimalPad
                default:
                    textField.keyboardType = .default
                }
            }
        }
    }
    
    func getField() -> (String, Any?) {
        
        switch fieldType {
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
