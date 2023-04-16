//
//  FormTableViewCell.swift
//  FormPractice
//
//  Created by guhan-pt6208 on 06/02/23.
//

import UIKit

protocol FormCellDelegate: AnyObject {
    
    func textFieldData(data: Any?, isValid: Bool, index: Int)
}

class FormTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "formCell"
    let label = UILabel()
    lazy var formTextField = FormTextField()
    lazy var lookupLabel = UILabel()
    lazy var switchButton = UISwitch()
    lazy var invalidLabel = UILabel()
    lazy var recordImageView = UIImageView()
    
    var isMandatory: Bool = false
    weak var delegate: FormCellDelegate?
    var index: Int!
    
    var textFieldHeight: NSLayoutConstraint?
    var texFieldTrailing: NSLayoutConstraint?
    var isWariningLabelShown = false
    
    var fieldType: String!
    
    var keyboardHeight: CGFloat = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        formTextField.text = nil
    }
    
    func configureCell() {
        
        configureLabel()
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
        
        contentView.addSubview(formTextField)
        formTextField.delegate = self
        formTextField.translatesAutoresizingMaskIntoConstraints = false
        formTextField.backgroundColor = .systemBackground
        formTextField.autocorrectionType = .no
        formTextField.autocapitalizationType = .none
        formTextField.returnKeyType = .done
        formTextField.keyboardType = .asciiCapable
        formTextField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            formTextField.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
            formTextField.topAnchor.constraint(equalTo: contentView.topAnchor)
            
        ])
        texFieldTrailing = formTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        textFieldHeight = formTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        texFieldTrailing?.isActive = true
        textFieldHeight?.isActive = true
    }
    
    @objc private func textFieldValueChanged() {
        
        let textFieldData = getFieldData(for: fieldType)
        delegate?.textFieldData(data: textFieldData.0, isValid: textFieldData.1, index: index)
    }
    
    func configureInvalidLabel() {
        
        if isMandatory && formTextField.text == "" {
            configureInvalidLabel(with: "This is Required")
        }
    }
    
    func configureInvalidLabel(with message: String?) {
        
        if isWariningLabelShown == false {
            
            isWariningLabelShown = true
            contentView.addSubview(invalidLabel)
            invalidLabel.translatesAutoresizingMaskIntoConstraints = false
            
            invalidLabel.textAlignment = .left
            invalidLabel.text = message
            invalidLabel.textColor = .red
            invalidLabel.font = .systemFont(ofSize: 15)
            
            NSLayoutConstraint.activate([

                invalidLabel.leadingAnchor.constraint(equalTo: formTextField.leadingAnchor, constant: 7),
                invalidLabel.topAnchor.constraint(equalTo: formTextField.bottomAnchor),
                invalidLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                invalidLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
            
            UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
                
                self?.textFieldHeight?.isActive = false
                self?.formTextField.removeConstraint((self?.textFieldHeight)!)
                
                self?.textFieldHeight = self?.formTextField.heightAnchor.constraint(equalToConstant: (self?.contentView.frame.height)!)
                
                self?.textFieldHeight?.isActive = true
            }
        }
    }
    
    func setUpCellWith(fieldName: String, isMandatory: Bool, cellIndex: Int, fieldType: String) {

        self.index = cellIndex
        self.isMandatory = isMandatory
        self.fieldType = fieldType
        
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
            label.textColor = .normalText
        }
    }
    
    func setLookupName(lookupApiName: String) { }
    
    func setRecordData(for data: Any, isEditable: Bool = true) {
        
        formTextField.text = data as? String
        formTextField.isUserInteractionEnabled = isEditable
//        self.isUserInteractionEnabled = isEditable
        configureIsCellEditable(isEditable)
        
    }
    
    // MARK: THIS SHOULD BE OVERRIDED IN EVERY TYPE CELL AND THERE IS NO NEED FOR (for Type) PARAMETER
    func getFieldData(for type: String) -> (Any?, Bool) {
        
        if isMandatory && formTextField.text == "" {
            configureInvalidLabel(with: "This field is Required")
            return ("" , false)
        }
    
        switch type {
            
        case "String":
            
            return (formTextField.text , true)
        default:
            
            return (formTextField.text, true)
        }
    }
}

extension FormTableViewCell {
    
    func configureIsCellEditable(_ isEditable: Bool) {
        
//        if !isEditable {
//            alpha = 0.5
//        }
        isUserInteractionEnabled = isEditable
        formTextField.isEnabled = isEditable
        if !isEditable {
            formTextField.textColor = .placeholderText
        }
//            label.isEnabled = isEditable
//            switchButton.isEnabled = isEditable
            
    }
}

extension FormTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
     }
}
