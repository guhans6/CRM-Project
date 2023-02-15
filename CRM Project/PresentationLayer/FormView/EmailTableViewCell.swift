//
//  EmailTableViewCell.swift
//  FormPractice
//
//  Created by guhan-pt6208 on 12/02/23.
//

import UIKit

class EmailTableViewCell: FormTableViewCell {

    static let emailCellIdentifier = "EmailCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLabel()
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureTextField() {
        
        super.configureTextField()
        textField.keyboardType = .emailAddress
    }
}
