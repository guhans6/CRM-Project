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

//        configureLookupLabel()
//        configureLookUpButton()
//        configureTextField()
        configureTextView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setLookupName(lookupApiName: String) {
        self.lookupApiName = lookupApiName
//        lookupVC = LookupTableViewController(module: lookupApiName)
//        lookupVC.delegate = self
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

//    private func configureLookupLabel() {
//        contentView.addSubview(lookupLabel)
//        lookupLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        lookupLabel.backgroundColor = .systemGray6
//
//        NSLayoutConstraint.activate([
//            lookupLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            lookupLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
//            lookupLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
//            lookupLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
//    }
    
    override func getFieldData(for type: String) -> (String, Any?) {
        
        if lookupId == nil {
            return (label.text!, nil)
        }
        return (label.text!, ["id": lookupId])
    }
    
    override func setRecordData(for data: String) {
        self.textView.text = data
    }
}

extension LookupTableViewCell: LookupTableViewDelegate {

    func getLookupRecordId(recordName: String, recordId: String) {

        self.textView.text = recordName
        self.lookupId = recordId
    }
}

//extension LookupTableViewCell: PickListDelegate {
//    
//    func getPickListValues(pickListId: String, pickListValue: [String]) {
//        self.textField.text = pickListValue.joined(separator: ",")
////        self.pic
//    }
//}
