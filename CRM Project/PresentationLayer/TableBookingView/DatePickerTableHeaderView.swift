//
//  DatePickerTableHeaderView.swift
//  CRM C
//
//  Created by guhan-pt6208 on 23/02/23.
//

import UIKit

class DatePickerTableHeaderView: UIView {
    
    private let selectDateLabel = UILabel()
    private let timeLabel = UILabel()
    let okButton = UIButton()
    let datePicker = UIDatePicker()
    let dropDownButton = DropDownButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        
        configureLabel()
        configureDatePicker()
        configureDropDownButton()
        configureButton()
    }
    
    private func configureLabel() {
        selectDateLabel.text = "Select date"
        selectDateLabel.textAlignment = .left
        selectDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(selectDateLabel)
        
        // Layout constraints for the label
        NSLayoutConstraint.activate([
            selectDateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            selectDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//            selectDateLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func configureDatePicker() {
        
//        self.addSubview(datePicker)
//        datePicker.datePickerMode = .date
//        datePicker.translatesAutoresizingMaskIntoConstraints = false
//
//
////        Layout constraints for the date picker
//        NSLayoutConstraint.activate([
//            datePicker.leadingAnchor.constraint(equalTo: selectDateLabel.trailingAnchor, constant: 40),
//            datePicker.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            //            datePicker.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
//            //            datePicker.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3)
//
//        ])
    }
    
    private func configureDropDownButton() {
        
        self.addSubview(dropDownButton)
        self.superview?.bringSubviewToFront(self)
        dropDownButton.translatesAutoresizingMaskIntoConstraints = false
        

        dropDownButton.button.setTitle("Pick Time", for: .normal)
        dropDownButton.button.setTitleColor(.label , for: .normal)
        dropDownButton.button.titleLabel?.font = .systemFont(ofSize: 20)
        dropDownButton.setDropDownOptions(options: ["a", "bb", "cccccccccccccc"])
        dropDownButton.button.backgroundColor = .red
        
        NSLayoutConstraint.activate([
            dropDownButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dropDownButton.leadingAnchor.constraint(equalTo: selectDateLabel.trailingAnchor, constant: 10),
//            dropDownButton.widthAnchor.constraint(equalToConstant: 150),
            
        ])
    }
    
    
    private func configureButton() {
        
//        self.addSubview(okButton)
//        okButton.translatesAutoresizingMaskIntoConstraints = false
//        okButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
//
//        NSLayoutConstraint.activate([
//            okButton.leadingAnchor.constraint(equalTo: dropDownButton.trailingAnchor, constant: 10),
//            okButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//        ])
    }
}
