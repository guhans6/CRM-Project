//
//  LookupTableViewCell.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 13/02/23.
//

import UIKit

class LookupTableViewCell: UITableViewCell {

    static let recordCellIdentifier = "lookupCell"
    private let lookupNameLabel = UILabel()
    private let lookupEmailLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureRecordNameLabel()
        configureRecordEmailLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureRecordNameLabel() {
        contentView.addSubview(lookupNameLabel)
        lookupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lookupNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            lookupNameLabel.centerYAnchor.constraint(lessThanOrEqualTo: contentView.centerYAnchor)
        ])
        
        
    }
    
    private func configureRecordEmailLabel() {
        contentView.addSubview(lookupEmailLabel)
        lookupEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        lookupEmailLabel.font = .systemFont(ofSize: 13)
        
        NSLayoutConstraint.activate([
            lookupEmailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            lookupEmailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            lookupEmailLabel.topAnchor.constraint(equalTo: lookupNameLabel.bottomAnchor, constant: 5)
        ])
    }
    
    private func reconfigureCell() {
        lookupEmailLabel.removeFromSuperview()
//        recordNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    }
    
    func configureRecordCell(recordName: String, secondaryData: String) {
        self.lookupNameLabel.text = recordName
        self.lookupEmailLabel.text = secondaryData
        
        if secondaryData == "" {
            reconfigureCell()
        }
    }

}
