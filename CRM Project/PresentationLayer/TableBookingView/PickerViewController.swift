//
//  PickerViewController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 25/02/23.
//

import UIKit

protocol PickerViewDelegate: AnyObject {
    
    func pickerViewData(datePickerDate: Date, tableviewSelectedRow: String)
}

class PickerViewController: UIViewController {

    private let datePicker = UIDatePicker()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let doneButton = UIButton()
    private lazy var resetButton = UIButton()
    
    private var tableViewData = [String]()
    
    private var lastPickedDate = Date()
    private var lastPickedTime = "Breakfast"
    private var sectionHeaderTitle: String?
    weak var delegate: PickerViewDelegate?
    
    enum ViewType {
        case tableView
        case dateView
    }
    
    init(tablviewData: [String] = [], headerTitle: String? = nil) {
        self.tableViewData = tablviewData
        self.sectionHeaderTitle = headerTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = .systemGray6
        
        configureDoneButton()
        configureDatePicker()
        configureTableView()
        reloadTableData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        datePickerValueChanged()
    }
    
    func showView(viewType: ViewType) {
        
        if viewType == .dateView {
            tableView.isHidden = true
            doneButton.isHidden = false
            datePicker.isHidden = false
            resetButton.isHidden = false
        } else {
            datePicker.isHidden = true
            doneButton.isHidden = true
            resetButton.isHidden = true
            tableView.isHidden = false
        }
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
        
        delegate?.pickerViewData(datePickerDate: lastPickedDate, tableviewSelectedRow: lastPickedTime)
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
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        let today = Date()
//        datePicker.minimumDate = today
        
        let calendar = Calendar.current
        let nextMonth = calendar.date(byAdding: .day, value: 30, to: today)!

//        datePicker.maximumDate = nextMonth
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
        configureResetButton()
    }
    
    @objc private func datePickerValueChanged() {
        
        if datePicker.date == Date() {
            resetButton.isHidden = true
        } else {
            resetButton.isHidden = false
        }
    }
    
    private func configureResetButton() {
        
        view.addSubview(resetButton)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        resetButton.setTitle("Today", for: .normal)
        resetButton.setTitleColor(.systemBlue, for: .normal)
        resetButton.titleLabel?.font = .systemFont(ofSize: 15)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        resetButton.isHidden = true
        
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10),
            resetButton.centerXAnchor.constraint(equalTo: datePicker.centerXAnchor),
        ])
    }
    
    @objc private func resetButtonTapped() {
        
        datePicker.date = Date()
        resetButton.isHidden = true
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func reloadTableData() {
        tableView.reloadData()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier) as! LabelTableViewCell
        
        let lableText = tableViewData[indexPath.row]
        
        cell.label.text = lableText
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let timing = tableViewData[indexPath.row]
        
        self.lastPickedTime = timing
        doneButtonTapped()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionHeaderTitle
    }
    
    
}

extension PickerViewController: FormTableViewDelegate {
    
    func getFields(fields: [Field]) {
        
        var pickListValues = [String]()
        for field in fields {
            if field.apiName == "Pick_List_1" && field.pickListValues.count > 0 {
                
                for index in 1 ..< field.pickListValues.count {
                    let pickListValue = field.pickListValues[index]
                    pickListValues.append((pickListValue.displayValue))
                }
                break
            }
        }
        tableViewData = pickListValues
        tableView.reloadData()
    }
}
