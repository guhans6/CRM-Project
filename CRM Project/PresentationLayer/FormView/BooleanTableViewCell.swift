//
//  BooleanTableViewCell.swift
//  FormPractice
//
//  Created by guhan-pt6208 on 12/02/23.
//

import UIKit

class BooleanTableViewCell: FormTableViewCell {

    static let booleanCellIdentifier = "BooleanCell"
    private let booleanTextField = FormTextField()  
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLabel()
        configureSwitch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSwitch() {
        textField.removeFromSuperview()
        contentView.addSubview(switchButton)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            switchButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    override func setRecordData(for data: String) {
//        print(data)
        if data == "true" {
            switchButton.isOn = true
        } else {
            switchButton.isOn = false
        }
    }
    
    // MARK: Can also override the get field
    override func getFieldData(for type: String) -> (String, Any?) {
        var value = false
        if switchButton.isOn {
            value = true
        }
        print(value)
        return (label.text!, value)
    }
}

