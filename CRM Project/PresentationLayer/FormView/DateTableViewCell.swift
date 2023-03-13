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
        formTextField.isUserInteractionEnabled = false
    }
    
    override func setRecordData(for data: Any, isEditable isRecordEditing: Bool = true) {
        formTextField.text = data as? String
        self.isUserInteractionEnabled = isRecordEditing
    }
    
    override func getFieldData(for type: String) -> (Any?, Bool) {
        
        
        // MARK: MUST CHANGE THIS LOGIC TO SOMEWHERE ELSE
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        if let date = dateFormatter.date(from: formTextField.text!) {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: date)
            
            return (formattedDate, true)
        } else {
            
            print("Invalid date string.")
            return (formTextField.text, false)
        }
        
    }
    
}

extension DateTableViewCell: PickerViewDelegate {
    
    
    func dateAndTime(date: Date, time: String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formattedDate = dateFormatter.string(from: date)
        
        self.formTextField.text = formattedDate
    }
    
}
