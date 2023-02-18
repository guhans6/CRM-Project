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

    var lookupApiName: String!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLookupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setLookupName(lookupApiName: String) {
        self.lookupApiName = lookupApiName
    }

    private func configureLookupLabel() {
        contentView.addSubview(lookupLabel)
        lookupLabel.translatesAutoresizingMaskIntoConstraints = false
        
        lookupLabel.backgroundColor = .systemGray6
        
        NSLayoutConstraint.activate([
            lookupLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lookupLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
            lookupLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            lookupLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func getFieldData(for type: String) -> (String, Any?) {
        
        if lookupId == nil {
            return (label.text!, nil)
        }
        return (label.text!, ["id": lookupId])
    }
    
    override func setRecordData(for data: String) {
        self.lookupLabel.text = data
    }
}

extension LookupTableViewCell: LookupTableViewDelegate {
    
    func getLookupRecordId(recordName: String, recordId: String) {
        self.lookupLabel.text = recordName
        self.lookupId = recordId
        print(lookupLabel.text, lookupApiName)
    }
}
