//
//  PickerViewController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 25/02/23.
//

import UIKit

protocol PickerViewDelegate {
    
    func dateAndTime(date: Date, time: String)
}

class PickerViewController: UIViewController {

    private let datePicker = UIDatePicker()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let doneButton = UIButton()
    var delegate: PickerViewDelegate?
    
    private var tableViewData = [String]()
    
    private var lastPickedDate = Date()
    private var lastPickedTime = "Breakfast"
    
    enum ViewType {
        case tableView
        case dateView
    }
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = .systemGray6
        
        configureDoneButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func showView(viewType: ViewType) {
        
        if viewType == .dateView {
            tableView.removeFromSuperview()
            configureDatePicker()
        } else {
            datePicker.removeFromSuperview()
            configureTableView()
        }
        print(viewType)
    }
    
    private func configureDoneButton() {
        
        view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.systemBlue, for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),

        ])
        
    }
    
    @objc private func doneButtonTapped() {
        lastPickedDate = self.datePicker.date
        
        delegate?.dateAndTime(date: lastPickedDate, time: lastPickedTime)
        dismiss(animated: true)
    }
    
    private func configureDatePicker() {
        
        view.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .background
        
        datePicker.layer.cornerRadius = 20
        datePicker.clipsToBounds = true
        
        let today = Date()
//        datePicker.minimumDate = today
        
        let calendar = Calendar.current
        let nextWeek = calendar.date(byAdding: .day, value: 30, to: today)!

        datePicker.maximumDate = nextWeek
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
    }
    
    private func configureTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .tableViewSeperator
        tableView.backgroundColor = .systemGray6
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.identifier)
        
        view.bringSubviewToFront(doneButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func getPickedDate() -> Date {
        return lastPickedDate
    }
    
    func getPickedTime() -> String {
        return lastPickedTime
    }
}

extension PickerViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier) as! LabelTableViewCell
        
        let timing = tableViewData[indexPath.row]
        
        cell.label.text = timing
        let selectedView = UIView()
        
        selectedView.backgroundColor = .tableSelect
        cell.selectedBackgroundView = selectedView
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let timing = tableViewData[indexPath.row]
        
        self.lastPickedTime = timing
        doneButtonTapped()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Pick a Time"
    }
}

extension PickerViewController: FormTableViewDelegate {
    
    func sendFields(fields: [Field]) {
        
        for field in fields {
            if field.apiName == "Pick_List_1" && field.pickListValues.count > 0 {
                
                for index in 1 ..< field.pickListValues.count {
                    let pickListValue = field.pickListValues[index]
                    tableViewData.append((pickListValue.displayValue))
                }
                break
            }
        }
        tableView.reloadData()
    }
}
