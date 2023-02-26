//
//  RecordInfoTableViewCell.swift
//  CRM C
//
//  Created by guhan-pt6208 on 14/02/23.
//

import UIKit

class RecordInfoTableViewCell: UITableViewCell {
    
    static let recordInfoCellIdentifier = "recordInfoCell"
    private let recordInfoNameLabel = UILabel()
    private let recordDataLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureRecordNameLabel()
        configureRecordDataLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureRecordNameLabel() {
        contentView.addSubview(recordInfoNameLabel)
        recordInfoNameLabel.translatesAutoresizingMaskIntoConstraints = false
        recordInfoNameLabel.textAlignment = .center
        recordInfoNameLabel.font = .preferredFont(forTextStyle: .body, compatibleWith: nil)
        
        NSLayoutConstraint.activate([
            recordInfoNameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            recordInfoNameLabel.centerYAnchor.constraint(lessThanOrEqualTo: contentView.centerYAnchor),
            recordInfoNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func configureRecordDataLabel() {
        contentView.addSubview(recordDataLabel)
        recordDataLabel.translatesAutoresizingMaskIntoConstraints = false
        recordDataLabel.font = .systemFont(ofSize: 15)
        
        NSLayoutConstraint.activate([
            recordDataLabel.leadingAnchor.constraint(equalTo: recordInfoNameLabel.trailingAnchor,constant: 10),
            recordDataLabel.centerYAnchor.constraint(lessThanOrEqualTo: contentView.centerYAnchor)
        ])
    }
    
    func setUpRecordInfoCell(recordName: String, recordData: String) {
        self.recordInfoNameLabel.text = recordName
        self.recordDataLabel.text = recordData
    }
    
}
