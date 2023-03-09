//
//  ModuleTableViewCell.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import UIKit

class LabelTableViewCell: UITableViewCell {
    
    static let identifier = "labelCell"
    private let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureModuleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.label.text = nil
        self.accessoryType = .none
    }
    
    private func configureModuleLabel() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .normalText
        label.font = .preferredFont(forTextStyle: .body)
        
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configureCellWith(text: String) {
        label.text = text
    }
}
