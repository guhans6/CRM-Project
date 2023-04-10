//
//  DateTableViewCell.swift
//  CRM C
//
//  Created by guhan-pt6208 on 27/02/23.
//

import UIKit

class DateTableViewCell: FormTableViewCell { // This shows datePicker
    
    static let dateCellIdentifier = "dateCell"
    private let dateButton = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLabel()
        configureTextField()
        configureDateButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureTextField() {
        super.configureTextField()
        
        formTextField.isUserInteractionEnabled = false
        
        formTextField.removeConstraint(texFieldTrailing!)
        texFieldTrailing?.isActive = false
        
        texFieldTrailing =  formTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25)
        texFieldTrailing?.isActive = true
    }
    
    private func configureDateButton() {
        
        
        contentView.addSubview(dateButton)
        dateButton.image = UIImage(systemName: "calendar")
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        dateButton.clipsToBounds = true
        dateButton.contentMode = .scaleAspectFit
        dateButton.tintColor = .gray
        dateButton.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
//            discloseIndicatorMark.leadingAnchor.constraint(equalTo: formTextField.trailingAnchor),
            dateButton.leadingAnchor.constraint(equalTo: formTextField.trailingAnchor),
            dateButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            dateButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dateButton.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    override func setRecordData(for data: Any, isEditable isRecordEditing: Bool = true) {
        formTextField.text = data as? String
//        self.isUserInteractionEnabled = isRecordEditing
        configureIsCellEditable(isRecordEditing)
        saveDateValue()
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
    
    private func saveDateValue() {
        
        let date = getFieldData(for: "")
        delegate?.textFieldData(data: date.0, isValid: true, index: index)
    }
    
}

extension DateTableViewCell: PickerViewDelegate {
    
    
    func pickerViewData(datePickerDate: Date, tableviewSelectedRow: String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formattedDate = dateFormatter.string(from: datePickerDate)
        
        self.formTextField.text = formattedDate
        
        saveDateValue()
    }
    
}
