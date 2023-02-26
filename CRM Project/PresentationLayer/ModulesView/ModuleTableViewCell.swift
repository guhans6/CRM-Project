//
//  ModuleTableViewCell.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import UIKit

class ModuleTableViewCell: UITableViewCell {
    
    static let moduleTableViewCellIdentifier = "moduleCell"
    private let moduleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureModuleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureModuleLabel() {
        contentView.addSubview(moduleLabel)
        moduleLabel.translatesAutoresizingMaskIntoConstraints = false
        moduleLabel.textColor = .normalText
        moduleLabel.font = .preferredFont(forTextStyle: .body)
        
        
        NSLayoutConstraint.activate([
            moduleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            moduleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setUpModule(moduleName: String) {
        moduleLabel.text = moduleName
    }
}
