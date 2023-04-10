//
//  LookupTableViewCell.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 13/02/23.
//

import UIKit

class LookupTableViewCell: FormTableViewCell {

    static let lookupCellIdentifier = "lookupCell"
    private var lookupId: String!
    private let discloseIndicatorMark = UIButton()

    var lookupApiName: String!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureTextField()
//        configureTextView()
        configureDiscloseIndicator()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setLookupName(lookupApiName: String) {
        self.lookupApiName = lookupApiName
        
    }
    
    private func configureDiscloseIndicator() {
        
        if UIView.userInterfaceLayoutDirection(
            for: self.semanticContentAttribute) == .leftToRight {
            
            discloseIndicatorMark.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        } else {
            
            discloseIndicatorMark.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        }
        
        contentView.addSubview(discloseIndicatorMark)
        discloseIndicatorMark.translatesAutoresizingMaskIntoConstraints = false
        discloseIndicatorMark.tintColor = .normalText
        discloseIndicatorMark.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
//            discloseIndicatorMark.leadingAnchor.constraint(equalTo: formTextField.trailingAnchor),
            discloseIndicatorMark.leadingAnchor.constraint(equalTo: formTextField.trailingAnchor),
            discloseIndicatorMark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            discloseIndicatorMark.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            discloseIndicatorMark.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }

    override func configureTextField() {
        super.configureTextField()
        
        
        formTextField.isUserInteractionEnabled = false
        
        formTextField.removeConstraint(texFieldTrailing!)
        texFieldTrailing?.isActive = false
        
        texFieldTrailing =  formTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21)
        texFieldTrailing?.isActive = true
    }
    
    override func getFieldData(for type: String) -> (Any?, Bool) {
        
        if lookupId == nil {
            return (nil, false)
        }
        
        return (["id": lookupId], true)
    }
    
    override func setRecordData(for data: Any, isEditable isRecordEditing: Bool) {
        
        
        if let lookupData = data as? [String] {
            
            self.lookupId = lookupData[0]
//            self.textView.text = lookupData[1]
            self.formTextField.text = lookupData[1]
        }
//        else if let lookupData = data as? String {
//            self.formTextField.text = lookupData
//        }
        
        saveLookupValue()
//        if !isRecordEditing {
//            formTextField.isEnabled = false
//            label.isEnabled = false
//        }
//        self.isUserInteractionEnabled = isRecordEditing
        configureIsCellEditable(isRecordEditing)
    }
    
    private func saveLookupValue() {
        
        let lookupData = getFieldData(for: "")
        delegate?.textFieldData(data: lookupData.0, isValid: true, index: index)
    }
}

extension LookupTableViewCell: RecordTableViewDelegate {

    func setLookupRecordAndId(recordName: String, recordId: String) {

        self.formTextField.text = recordName
        self.lookupId = recordId
        
        saveLookupValue()
    }
}
