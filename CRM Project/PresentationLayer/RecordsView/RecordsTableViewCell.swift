//
//  RecordsTableViewCell.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import UIKit

class RecordsTableViewCell: UITableViewCell {

    static let recordCellIdentifier = "recordCell"
    private let recordNameLabel = UILabel()
    private let recordEmailLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureRecordNameLabel()
        configureRecordEmailLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureRecordNameLabel() {
        contentView.addSubview(recordNameLabel)
        recordNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recordNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            recordNameLabel.centerYAnchor.constraint(lessThanOrEqualTo: contentView.centerYAnchor)
        ])
        
        
    }
    
    private func configureRecordEmailLabel() {
        contentView.addSubview(recordEmailLabel)
        recordEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        recordEmailLabel.font = .systemFont(ofSize: 13)
        
        NSLayoutConstraint.activate([
            recordEmailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            recordEmailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            recordEmailLabel.topAnchor.constraint(equalTo: recordNameLabel.bottomAnchor, constant: 5)
        ])
    }
    
    private func reconfigureCell() {
        recordEmailLabel.removeFromSuperview()
//        recordNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    }
    
    func configureRecordCell(recordName: String, secondaryData: String) {
        self.recordNameLabel.text = recordName
        self.recordEmailLabel.text = secondaryData
        
        if secondaryData == "" {
            reconfigureCell()
        }
    }

}
