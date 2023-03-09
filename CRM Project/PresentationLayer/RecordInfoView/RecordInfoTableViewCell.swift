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
        recordInfoNameLabel.textAlignment = .left
        recordInfoNameLabel.font = .preferredFont(forTextStyle: .body)
        recordInfoNameLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            
            recordInfoNameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            recordInfoNameLabel.centerYAnchor.constraint(lessThanOrEqualTo: contentView.centerYAnchor),
            recordInfoNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func configureRecordDataLabel() {
        contentView.addSubview(recordDataLabel)
        recordDataLabel.translatesAutoresizingMaskIntoConstraints = false
        recordDataLabel.font = .systemFont(ofSize: 17)
        recordDataLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
//            recordDataLabel
//                .leadingAnchor.constraint(equalTo: recordInfoNameLabel.trailingAnchor,constant: 20),

            recordDataLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
            recordDataLabel
                .centerYAnchor.constraint(lessThanOrEqualTo: contentView.centerYAnchor),
            
            recordDataLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setUpRecordInfoCell(recordName: String, recordData: Any) {
        
        self.recordInfoNameLabel.text = recordName
            
        if let recordData = recordData as? String {
            self.recordDataLabel.text = recordData
            
        } else if let recordData = recordData as? [String] {
            
            self.recordDataLabel.text = recordData[1]
        }
            
    }
    
}
