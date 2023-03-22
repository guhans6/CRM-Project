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
    private let recordView = UIView()
    
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
            
            recordInfoNameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            recordInfoNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.centerXAnchor),
            recordInfoNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            recordInfoNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -15)
            
        ])
    }
    
    private func configureRecordDataLabel() {
        contentView.addSubview(recordDataLabel)
        recordDataLabel.translatesAutoresizingMaskIntoConstraints = false
        recordDataLabel.font = .preferredFont(forTextStyle: .body)
        recordDataLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([

            recordDataLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            recordDataLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            recordDataLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10),
            recordDataLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setUpRecordInfoCell(recordName: String, recordData: Any) {
        
        self.recordInfoNameLabel.text = recordName
            
        if let recordData = recordData as? String {
            self.recordDataLabel.text = recordData
            
        } else if let recordData = recordData as? [String] {
            
            self.recordDataLabel.text = recordData[1]
        } else if let recordData = recordData as? Int {
            
            self.recordDataLabel.text = String(recordData)
        } else if let recordData = recordData as? Double {
            
            self.recordDataLabel.text = String(recordData)
        }
            
    }
    
}
