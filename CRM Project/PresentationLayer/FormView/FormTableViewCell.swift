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
    lazy var formTextField = FormTextField()
    lazy var lookupLabel = UILabel()
    lazy var switchButton = UISwitch()
    lazy var invalidLabel = UILabel()
    var isMandatory: Bool = false
    
    var textFieldHeight: NSLayoutConstraint?
    var texFieldTrailing: NSLayoutConstraint?
    var isWariningLabelShown = false
    
    var fieldType: String!
    
    var activeTextField: UITextField?
    var keyboardHeight: CGFloat = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLabel()
        configureCell()
        formTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
    
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let activeTextField = activeTextField
        else {
            return
        }

        // Save the keyboard height and set the content inset to move the table view up
        
        // Keyboard Height
        keyboardHeight = keyboardFrame.height
//        let keyboardTopY = keyboardFrame.origin.y - keyboardHeight
        
        // The below is to find bounds of activeTextFields Rect according to it's superview
        let textFieldRect = activeTextField.convert(activeTextField.bounds, to: self.superview)
        
        // The below is to find the bottom position of textField in the rectangle
        let textFieldBottom = textFieldRect.origin.y + textFieldRect.size.height
        
        // So if the bottom is greater than keyboard's height it will move the view up
        // We are checking if it is Greater because y increase in the way down and x increases on right form (0, 0) on phone's top left
        
        if textFieldBottom > keyboardHeight && superview?.frame.origin.y == 0 {
            
            superview?.frame.origin.y -= keyboardHeight
            if let parentVC = self.next?.next as? UIViewController {
                
                parentVC.navigationController?.navigationBar.isHidden = true
            }
        }
    }


    @objc private func keyboardWillHide(_ notification: Notification) {
        
        // Move the view back down to its original position
        superview?.frame.origin.y = 0
        if let parentVC = self.next?.next as? UIViewController {
            
            parentVC.navigationController?.navigationBar.isHidden = false
        }
    }
    
    func configureLabel() {
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
//        label.backgroundColor =
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            label.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -10)
        ])
    }
    
    func configureTextField() {
        
        contentView.addSubview(formTextField)
        formTextField.translatesAutoresizingMaskIntoConstraints = false
        formTextField.backgroundColor = .systemBackground
        formTextField.autocorrectionType = .no
        formTextField.autocapitalizationType = .none
        formTextField.returnKeyType = .done
        
        NSLayoutConstraint.activate([
            formTextField.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
            formTextField.topAnchor.constraint(equalTo: contentView.topAnchor)
            
        ])
        texFieldTrailing = formTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        textFieldHeight = formTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        texFieldTrailing?.isActive = true
        textFieldHeight?.isActive = true
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
                //            invalidLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                invalidLabel.leadingAnchor.constraint(equalTo: formTextField.leadingAnchor),
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
    
    func setUpCellWith(fieldName: String, isMandatory: Bool) {

        self.isMandatory = isMandatory
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
    
    func setRecordData(for data: Any, isEditable: Bool = true) {
        
        formTextField.text = data as? String
        formTextField.isUserInteractionEnabled = isEditable
        self.isUserInteractionEnabled = isEditable
        
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

extension FormTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeTextField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }

}
