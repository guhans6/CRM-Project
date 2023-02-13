//
//  LookupTableViewCell.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 13/02/23.
//

import UIKit

class LookupTableViewCell: FormTableViewCell {

    static let lookupCellIdentifier = "lookupCell"
    private var lookupName: String!
    private var lookupId: String!
    private var lookupVC: LookupTableViewController!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLookUpButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setLookupName(lookupApiName: String) {
        lookupName = lookupApiName
        lookupVC = LookupTableViewController(module: lookupName)
        lookupVC.delegate = self
    }

    private func configureLookUpButton() {
        contentView.addSubview(lookupButton)
        lookupButton.translatesAutoresizingMaskIntoConstraints = false
//        lookupButton.setTitle("Okay", for: .normal)
        
        lookupButton.backgroundColor = .systemGray6
        lookupButton.addTarget(self, action: #selector(lookupButtonClicked), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            lookupButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lookupButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
            lookupButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            lookupButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @objc private func lookupButtonClicked() {
        // MARK: Change this to the while loop method and learn about UIResponder
        
        let formVC = self.next?.next as! FormTableViewController
        formVC.navigationController?.pushViewController(lookupVC, animated: true)
    }
    
    override func getFieldData(for type: String) -> (String, Any?) {
        
        if lookupId == nil {
            return (label.text!, nil)
        }
        return (label.text!, ["id": lookupId])
    }
}

extension LookupTableViewCell: LookupTableViewDelegate {
    
    func getLookupRecordId(recordName: String, recordId: String) {
        self.lookupButton.setTitle(recordName, for: .normal)
        self.lookupId = recordId
    }
}
