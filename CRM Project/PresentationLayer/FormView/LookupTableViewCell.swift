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
    let textView = UILabel()

    var lookupApiName: String!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureTextField()
//        configureTextView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setLookupName(lookupApiName: String) {
        self.lookupApiName = lookupApiName
    }


    override func configureTextField() {
        super.configureTextField()
//        textField.backgroundColor = .systemGray6
        textField.isUserInteractionEnabled = false
        
    }
    
    func configureTextView() {
        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .systemGray6
        textView.numberOfLines = 0

        
        NSLayoutConstraint.activate([
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configureLookupLabel() {
        
        contentView.addSubview(lookupLabel)
        lookupLabel.translatesAutoresizingMaskIntoConstraints = false
        lookupLabel.numberOfLines = 0
        lookupLabel.lineBreakMode = .byWordWrapping
        
        NSLayoutConstraint.activate([
            lookupLabel.leadingAnchor.constraint(equalTo: label.trailingAnchor,constant: 20),
            lookupLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            lookupLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            lookupLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
//        contentView.addSubview(lookupLabel)
//        lookupLabel.translatesAutoresizingMaskIntoConstraints = false
//        lookupLabel.backgroundColor = .lightText
//        lookupLabel.numberOfLines = 0
//

//        NSLayoutConstraint.activate([
////            lookupLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            lookupLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
//            lookupLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
//            lookupLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
        

    }
    
    override func getFieldData(for type: String) -> (String, Any?) {
        
        if lookupId == nil {
            return (label.text!, nil)
        }
        return (label.text!, ["id": lookupId])
    }
    
    override func setRecordData(for data: Any) {
        
        let lookUpData = data as! [String]
        
        self.lookupId = lookUpData[0]
        self.textField.text = lookUpData[1]
        
    }
}

extension LookupTableViewCell: LookupTableViewDelegate {

    func setLookupRecordAndId(recordName: String, recordId: String) {

        self.textField.text = recordName
        self.lookupId = recordId
    }
}
