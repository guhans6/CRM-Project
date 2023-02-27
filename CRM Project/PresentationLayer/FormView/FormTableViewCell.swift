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
//    lazy var textField = FormTextField()
    lazy var lookupLabel = UILabel()
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
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            label.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -10)
        ])
    }
    
    func configureTextField() {
        
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .lightText
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        
        // MARK: BELOW IS USED TO SET CUSTOM BORDER
//        textField.layer.borderColor = UIColor.systemGray6.withAlphaComponent(0.5).cgColor
//        textField.layer.borderWidth = 2.0
        textField.backgroundColor = .systemGray6
        
        NSLayoutConstraint.activate([
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setUpCellWith(fieldName: String, isMandatory: Bool) {

        if isMandatory {
            let fieldNameString = fieldName
            let starString = "*"

            let fieldNameAttributes = [NSAttributedString.Key.foregroundColor: UIColor.normalText]
            let starAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]

            let attributedString = NSMutableAttributedString(string: fieldNameString, attributes: fieldNameAttributes as [NSAttributedString.Key : Any])
            attributedString.append(NSAttributedString(string: starString, attributes: starAttributes))

            label.attributedText = attributedString
        } else {
            label.text = fieldName
        }

    }
    
    func setLookupName(lookupApiName: String) { }
    
    func setRecordData(for data: String) {
        textField.text = data
//        print(textField.text)
    }
    
    // MARK: THIS SHOULD BE OVERRIDED IN EVERY TYPE CELL AND THERE IS NO NEED FOR (for Type) PARAMETER
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
        default:
            return (label.text!, textField.text)
        }
    }
}
