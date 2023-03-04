//
//  StringTableViewCell.swift
//  FormPractice
//
//  Created by guhan-pt6208 on 10/02/23.
//

import UIKit

class StringTableViewCell: FormTableViewCell {

    static let stringCellIdentifier = "StringCell"
    
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
        formTextField.keyboardType = .default
    }
}
