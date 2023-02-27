//
//  DateTableViewCell.swift
//  CRM C
//
//  Created by guhan-pt6208 on 27/02/23.
//

import UIKit

class DateTableViewCell: FormTableViewCell { // This shows datePicker
    
    static let dateCellIdentifier = "dateCell"
    
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
        textField.isUserInteractionEnabled = false
    }
    
    override func setRecordData(for data: String) {
        textField.text = data
    }
    
    
}

extension DateTableViewCell: PickerViewDelegate {
    
    
    func dateAndTime(date: Date, time: String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formattedDate = dateFormatter.string(from: date)
        
        self.textField.text = formattedDate
    }
    
}
