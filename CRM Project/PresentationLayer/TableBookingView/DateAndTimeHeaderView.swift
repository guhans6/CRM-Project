//
//  DatePickerTableHeaderView.swift
//  CRM C
//
//  Created by guhan-pt6208 on 23/02/23.
//

import UIKit

class DateAndTimeHeaderView: UIView {
    
    private let selectDateLabel = UILabel()
    let dateDisplayButton = UIButton()
    private let timeLabel = UILabel()
    let timeDisplayButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        
        configureLabel()
        configureDateDisplayButton()
        
        configureTimeLabel()
        configureTimeDisplayButton()
    }
    
    private func configureLabel() {
        
        selectDateLabel.text = "Select date: "
        selectDateLabel.textAlignment = .left
        selectDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(selectDateLabel)
        
        // Layout constraints for the label
        NSLayoutConstraint.activate([
//            selectDateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            selectDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            selectDateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15)
        ])
    }

    private func configureDateDisplayButton() {
        
        self.addSubview(dateDisplayButton)
//        self.superview?.bringSubviewToFront(self)
        dateDisplayButton.translatesAutoresizingMaskIntoConstraints = false
        
        let date = Date()
        let todayDate = DateFormatter.formattedString(from: date, format: "dd-MM-yyyy")
        
        dateDisplayButton.setTitle(todayDate, for: .normal)
        dateDisplayButton.setTitleColor(.normalText, for: .normal)
        dateDisplayButton.layer.cornerRadius = 7
        
        dateDisplayButton.backgroundColor = .tableSelect
        
        NSLayoutConstraint.activate([
            dateDisplayButton.centerYAnchor.constraint(equalTo: selectDateLabel.centerYAnchor),
            dateDisplayButton.leadingAnchor.constraint(equalTo: selectDateLabel.trailingAnchor, constant: 30),
            dateDisplayButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            dateDisplayButton.heightAnchor.constraint(equalToConstant: 40),
//            dateDisplayButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2)
            
        ])
    }
    
    private func configureTimeLabel() {
        
        timeLabel.text = "Select Time: "
        timeLabel.textAlignment = .left
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(timeLabel)
        
        // Layout constraints for the label
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: selectDateLabel.bottomAnchor, constant: 30),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
        ])
    }
    
    private func configureTimeDisplayButton() {
        
        self.addSubview(timeDisplayButton)
//        self.superview?.bringSubviewToFront(self)
        timeDisplayButton.translatesAutoresizingMaskIntoConstraints = false
        
        timeDisplayButton.setTitle("Breakfast", for: .normal)
        timeDisplayButton.setTitleColor(.normalText, for: .normal)
        timeDisplayButton.layer.cornerRadius = 7
        
        timeDisplayButton.backgroundColor = .tableSelect
        
        NSLayoutConstraint.activate([
            timeDisplayButton.leadingAnchor.constraint(equalTo: dateDisplayButton.leadingAnchor),
            timeDisplayButton.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            timeDisplayButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            timeDisplayButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
}
