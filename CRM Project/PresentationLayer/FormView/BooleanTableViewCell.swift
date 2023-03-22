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
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func configureSwitch() {
        formTextField.removeFromSuperview()
        
        contentView.addSubview(switchButton)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        switchButton.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        NSLayoutConstraint.activate([
            switchButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func switchValueChanged() {
        
        let switchData = getFieldData(for: "")
        delegate?.textFieldData(data: switchData.0, isValid: switchData.1, index: index)
    }
    
    override func setRecordData(for data: Any, isEditable isRecordEditing: Bool = true) {

        self.isUserInteractionEnabled = isRecordEditing
        
        if data as? Bool == true || data as? String == "Yes" {
            print(data, data)
            switchButton.isOn = true
        } else {
            print(data)
            switchButton.isOn = false
        }
    }
    
    // MARK: Can also override the get field
    override func getFieldData(for type: String) -> (Any?, Bool) {
        
        var value = false
        if switchButton.isOn {
            value = true
        }

        return (value, true)
    }
}

