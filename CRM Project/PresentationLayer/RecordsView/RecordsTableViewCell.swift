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
        
        nameLabelCenterYAnchor = recordNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        nameLabelCenterYAnchor?.priority = .defaultHigh
        nameLabelCenterYAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            recordNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            recordNameLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureRecordEmailLabel() {
        
        nameLabelCenterYAnchor?.isActive = false
        recordNameLabel.removeConstraint(nameLabelCenterYAnchor!)
        recordNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = translatesAutoresizingMaskIntoConstraints
    
        contentView.addSubview(secondaryLabel)
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.font = .preferredFont(forTextStyle: .caption1)
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
