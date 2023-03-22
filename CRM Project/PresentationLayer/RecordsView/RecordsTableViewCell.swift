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
    private let secondaryLabel = UILabel()
    
    private var nameLabelCenterYAnchor: NSLayoutConstraint?
    private var nameLabelTop: NSLayoutConstraint?
    private var nameLabelBottom: NSLayoutConstraint?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureRecordNameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureRecordNameLabel() {
        
        contentView.addSubview(recordNameLabel)
        recordNameLabel.translatesAutoresizingMaskIntoConstraints = false
        recordNameLabel.font = .preferredFont(forTextStyle: .body)
        recordNameLabel.numberOfLines = 0
        
        nameLabelTop = recordNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13)
        
        nameLabelBottom = recordNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13)
        
        NSLayoutConstraint.activate([
            nameLabelTop!,
            nameLabelBottom!,
            recordNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            recordNameLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureRecordEmailLabel() {
        
        
        nameLabelTop?.isActive = false
        nameLabelBottom?.isActive = false

        recordNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    
        contentView.addSubview(secondaryLabel)
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.font = .preferredFont(forTextStyle: .footnote)
        secondaryLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            secondaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            secondaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            secondaryLabel.topAnchor.constraint(equalTo: recordNameLabel.bottomAnchor, constant: 5),
            secondaryLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)
            
        ])
    }
    
    private func reconfigureCell() {
        secondaryLabel.removeFromSuperview()

    }
    
    func configureRecordCell(recordName: String, secondaryData: String) {
        self.recordNameLabel.text = recordName
        
        if secondaryData != "" {
            
            configureRecordEmailLabel()
            self.secondaryLabel.text = secondaryData
        }
    }

}
