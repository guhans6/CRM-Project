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

class MyPickerViewController: UIViewController {

    private let segmentedControl = UISegmentedControl()
    private let datePicker = UIDatePicker()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let okayButton = UIButton()
    var delegate: PickerViewDelegate?
    private var timings = [String]()
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
        
        view.backgroundColor = .systemBackground
        
//        configureSegmentedControl()
//        configureDatePicker()
        configureOkayButton()
//        configureTableView()
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
    
    private func configureOkayButton() {
        
        view.addSubview(okayButton)
        okayButton.translatesAutoresizingMaskIntoConstraints = false
//        okayButton.backgroundColor = .red
        okayButton.setTitle("Done", for: .normal)
        okayButton.setTitleColor(.systemBlue, for: .normal)
        okayButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            okayButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            okayButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),

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
        
        let today = Date()
        datePicker.minimumDate = today
        
        let calendar = Calendar.current
        let nextWeek = calendar.date(byAdding: .day, value: 30, to: today)!

        datePicker.maximumDate = nextWeek
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            datePicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
        ])
    }
    
    private func configureTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .tableViewSeperator
        tableView.backgroundColor = .systemBackground
//        tableView.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor ,constant: 70),
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

extension MyPickerViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        timings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let timing = timings[indexPath.row]
        
        cell.textLabel?.text = timing
        let selectedView = UIView()
        selectedView.backgroundColor = .tableSelect
        cell.selectedBackgroundView = selectedView
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let timing = timings[indexPath.row]
        
        self.lastPickedTime = timing
        doneButtonTapped()
    }
}

extension MyPickerViewController: FormTableViewDelegate {
    
    func sendFields(fields: [Field]) {
        
        for field in fields {
            if field.apiName == "Pick_List_1" {
                
                for index in 1 ..< field.pickListValues.count {
                    let pickListValue = field.pickListValues[index]
                    timings.append((pickListValue.displayValue))
                }
                tableView.reloadData()
                break
            }
        }
    }
}
