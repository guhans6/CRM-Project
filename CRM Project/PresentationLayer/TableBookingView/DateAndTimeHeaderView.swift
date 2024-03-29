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
        
        selectDateLabel.text = "Date: ".localized()
        selectDateLabel.textAlignment = .left
        selectDateLabel.translatesAutoresizingMaskIntoConstraints = false
        selectDateLabel.font = .systemFont(ofSize: 20, weight: .regular)
        self.addSubview(selectDateLabel)
        
        // Layout constraints for the label
        NSLayoutConstraint.activate([
            selectDateLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -70),
//            selectDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            selectDateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15)
        ])
    }

    private func configureDateDisplayButton() {
        
        self.addSubview(dateDisplayButton)
        dateDisplayButton.translatesAutoresizingMaskIntoConstraints = false
        
        let date = Date()
        let todayDate = DateFormatter.formattedString(from: date, format: "dd-MM-yyyy")
        
        dateDisplayButton.setTitle(todayDate, for: .normal)
        dateDisplayButton.setTitleColor(.label, for: .normal)
        dateDisplayButton.layer.cornerRadius = 7
        
        dateDisplayButton.backgroundColor = .tableSelect
        
        NSLayoutConstraint.activate([
            dateDisplayButton.centerYAnchor.constraint(equalTo: selectDateLabel.centerYAnchor),
            dateDisplayButton.leadingAnchor.constraint(equalTo: self.centerXAnchor),
            dateDisplayButton.widthAnchor.constraint(equalToConstant: 140),
            dateDisplayButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func setDate(date: Date) {
        
        let convertedDate = DateFormatter.formattedString(from: date, format: "dd-MM-yyyy")
        dateDisplayButton.setTitle(convertedDate, for: .normal)
    }
    
    private func configureTimeLabel() {
        
        timeLabel.text = "Time: "
        timeLabel.textAlignment = .left
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = .systemFont(ofSize: 20, weight: .regular)
        
        self.addSubview(timeLabel)
        
        // Layout constraints for the label
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: selectDateLabel.bottomAnchor, constant: 30),
            timeLabel.leadingAnchor.constraint(equalTo: selectDateLabel.leadingAnchor),
        ])
    }
    
    private func configureTimeDisplayButton() {
        
        self.addSubview(timeDisplayButton)
//        self.superview?.bringSubviewToFront(self)
        timeDisplayButton.translatesAutoresizingMaskIntoConstraints = false
        
        timeDisplayButton.setTitle("Breakfast", for: .normal)
        timeDisplayButton.setTitleColor(.label, for: .normal)
        timeDisplayButton.layer.cornerRadius = 7
        
        timeDisplayButton.backgroundColor = .tableSelect
        
        NSLayoutConstraint.activate([
            timeDisplayButton.leadingAnchor.constraint(equalTo: dateDisplayButton.leadingAnchor),
            timeDisplayButton.trailingAnchor.constraint(equalTo: dateDisplayButton.trailingAnchor),
            timeDisplayButton.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            timeDisplayButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
}
