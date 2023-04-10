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
    private let recordImageView = UIImageView()
    private let defaultImage = UIImage(named: "camera")
    
    private var nameLabelCenterYAnchor: NSLayoutConstraint?
    private var nameLabelTop: NSLayoutConstraint?
    private var nameLabelBottom: NSLayoutConstraint?
    private var nameLabelConstraints: [NSLayoutConstraint]?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureImageView()
        configureRecordNameLabel()
        backgroundColor = .systemGray6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutMarginsDidChange() {
        
        if secondaryLabel.text == "" {
            
            nameLabelTop?.isActive = false
            nameLabelBottom?.isActive = false
            
            recordNameLabel.removeConstraints([nameLabelTop!, nameLabelBottom!])
            nameLabelTop = recordNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
            nameLabelTop?.isActive = true

            nameLabelBottom = recordNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            nameLabelBottom?.isActive = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        recordNameLabel.text = nil
        secondaryLabel.text = nil
        recordImageView.image = defaultImage
    }
    
    private func configureImageView() {
        
        contentView.addSubview(recordImageView)
        recordImageView.translatesAutoresizingMaskIntoConstraints = false
        recordImageView.contentMode = .scaleAspectFill
        recordImageView.layer.cornerRadius = 25
        recordImageView.clipsToBounds = true
        recordImageView.backgroundColor = .systemGray5
        recordImageView.image = defaultImage
        
        NSLayoutConstraint.activate([
            recordImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            recordImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            recordImageView.widthAnchor.constraint(equalToConstant: 50),
            recordImageView.heightAnchor.constraint(equalToConstant: 50)
        ])

    }
    
    private func configureRecordNameLabel() {
        
        contentView.addSubview(recordNameLabel)
        recordNameLabel.translatesAutoresizingMaskIntoConstraints = false
        recordNameLabel.font = .preferredFont(forTextStyle: .body)
        recordNameLabel.numberOfLines = 0
        
        let minHeightConstraint = recordNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        minHeightConstraint.priority = UILayoutPriority(rawValue: 999)
        minHeightConstraint.isActive = true
        
        nameLabelTop = recordNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        nameLabelTop?.isActive = true

        nameLabelBottom = recordNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        nameLabelBottom?.isActive = true
        
        NSLayoutConstraint.activate([
            recordNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            recordNameLabel.trailingAnchor.constraint(equalTo: recordImageView.leadingAnchor)
        ])
    }
    
    func configureRecordEmailLabel() {
        
        nameLabelTop?.isActive = false
        nameLabelBottom?.isActive = false
        
        recordNameLabel.removeConstraints([nameLabelTop!, nameLabelBottom!])
    
        nameLabelTop = recordNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        nameLabelTop?.isActive = true
    
        contentView.addSubview(secondaryLabel)
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.font = .preferredFont(forTextStyle: .footnote)
        secondaryLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            secondaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            secondaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            secondaryLabel.topAnchor.constraint(equalTo: recordNameLabel.bottomAnchor, constant: 5),
            secondaryLabel.trailingAnchor.constraint(lessThanOrEqualTo: recordImageView.leadingAnchor)
            
        ])
    }
    
    private func reconfigureCell() {
        
        secondaryLabel.removeFromSuperview()
        
        if nameLabelTop?.isActive == false {
            
            nameLabelTop?.isActive = true
            nameLabelBottom?.isActive = true
        }
    }
    
    func configureRecordCell(recordName: String, secondaryData: String, recordImage: UIImage?) {
        
        self.recordNameLabel.text = recordName
        if let recordImage = recordImage {
            recordImageView.image = recordImage
        }
        
        if secondaryData != "" {
            
            configureRecordEmailLabel()
            self.secondaryLabel.text = secondaryData
        }
    }

}

extension RecordsTableViewCell {
    
    func removeImageView() {
        
        recordImageView.removeFromSuperview()
    }
}
