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
    let textView = UITextView()
    let discloseIndicatorMark = UIButton()

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
    
    func configureDiscloseIndicator() {
        
        contentView.addSubview(discloseIndicatorMark)
        discloseIndicatorMark.translatesAutoresizingMaskIntoConstraints = false
        discloseIndicatorMark.setImage(UIImage(systemName: "chevron.right"), for: .normal)
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
    
    func configureTextView() {
        
        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemBackground
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 13, left: 7, bottom: 0, right: 0)
        textView.isEditable = false
        
        NSLayoutConstraint.activate([
//            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21),
            textView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),

        ])
        textFieldHeight = textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        textFieldHeight?.isActive = true
        
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
        } else if let lookupData = data as? String {
            self.formTextField.text = lookupData
        }
//        self.textView.isEditable = isRecordEditing
        self.isUserInteractionEnabled = isRecordEditing
        
    }
}

extension LookupTableViewCell: RecordTableViewDelegate {

    func setLookupRecordAndId(recordName: String, recordId: String) {

        self.formTextField.text = recordName
        self.lookupId = recordId
    }
}
