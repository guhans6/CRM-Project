//
//  HomeViewCell.swift
//  CRM C
//
//  Created by guhan-pt6208 on 10/04/23.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    static let identifier = "homeCell"
    private let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLabel()
        backgroundColor = .systemGray6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.label.text = nil
        label.textAlignment = .natural
        self.accessoryType = .none
    }
    
    private func configureLabel() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .normalText
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
    }
    
    func configureCellWith(text: String) {
        label.text = text
    }
}

