//
//  DatePickerTableHeaderView.swift
//  CRM C
//
//  Created by guhan-pt6208 on 23/02/23.
//

import UIKit

class DatePickerTableHeaderView: UIView {
    
    let datePicker = UIDatePicker()
    let selectDateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderWidth = .leastNormalMagnitude
        self.layer.borderColor = CGColor(gray: 1, alpha: 0.4)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        selectDateLabel.text = "Select date"
        selectDateLabel.textAlignment = .left
        selectDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(selectDateLabel)
        
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(datePicker)
        
        // Layout constraints for the label
        NSLayoutConstraint.activate([
            selectDateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            selectDateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -60),
//            selectDateLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5)
        ])
        
//         Layout constraints for the date picker
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: selectDateLabel.trailingAnchor, constant: 40),
            datePicker.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            datePicker.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
//            datePicker.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3)

        ])
    }
}
