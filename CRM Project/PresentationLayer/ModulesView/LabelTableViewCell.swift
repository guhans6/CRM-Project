//
//  ModuleTableViewCell.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import UIKit

class LabelTableViewCell: UITableViewCell {
    
    static let identifier = "labelCell"
    let darkModeSwitch = UISwitch()
    let label = UILabel()

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
        label.textColor = .normalText
        self.accessoryType = .none
        darkModeSwitch.removeFromSuperview()
        self.gestureRecognizers = []
    }
    
    @objc private func dummyTap() {
        
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
    
    private func configureDarkModeSwitch() {
        
        contentView.addSubview(darkModeSwitch)
        darkModeSwitch.translatesAutoresizingMaskIntoConstraints = false
        darkModeSwitch.onTintColor = .tableSelect
        
        NSLayoutConstraint.activate([
            darkModeSwitch.centerYAnchor.constraint(equalTo: label.centerYAnchor),
//            darkModeSwitch.leadingAnchor.constraint(equalTo: label.trailingAnchor)
            darkModeSwitch.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -15)
            
        ])
    }
    
    func configureCellWith(text: String) {
        
        if text == "Functions" {
            label.text = "Events"
        } else {
            label.text = text
        }
    }
    
    func addSwitch() {
        
        configureDarkModeSwitch()
    }
}
