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
    private let tableView = UITableView()
    private let okayButton = UIButton()
    var delegate: PickerViewDelegate?
    var timings = [(String, String)]()
    var lastPickedDate = Date()
    
    override func viewDidLoad() {
        
        view.backgroundColor = .systemBackground
        
        configureDatePicker()
        configureOkayButton()
//        configureSegmentedControl()
//        configureTableView()
//        getTimings()
    }
    
    private func configureSegmentedControl() {
        
        view.addSubview(segmentedControl)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Pick Date", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Pick time", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30)
//            dropDownButton.widthAnchor.constraint(equalToConstant: 150),
            
        ])
    }
    
    @objc private func segmentValueChanged(_ segmentedControl: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            tableView.isHidden = true
            datePicker.isHidden = false
//            configureDatePicker()
        case 1:
            datePicker.isHidden = true
            tableView.isHidden = false
//            configureTableView()
        default :
            print("case Default")
        }
        
    }
    
    func configureOkayButton() {
        
        view.addSubview(okayButton)
        okayButton.translatesAutoresizingMaskIntoConstraints = false
//        okayButton.backgroundColor = .red
        okayButton.setTitle("Done", for: .normal)
        okayButton.setTitleColor(.systemBlue, for: .normal)
        okayButton.addTarget(self, action: #selector(okayButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            okayButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            okayButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),

        ])
        
    }
    
    @objc private func okayButtonTapped() {
        lastPickedDate = self.datePicker.date
        
        delegate?.dateAndTime(date: lastPickedDate, time: "Meal")
        dismiss(animated: true)
    }
    
    private func configureDatePicker() {
        
        view.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
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
        tableView.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor ,constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func getTimings() {
        BookingController().getAllTimings { timings in
            self.timings = timings
            tableView.reloadData()
        }
    }
    
    func getLastPickedDate() -> Date {
        return lastPickedDate
    }
}

extension MyPickerViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        timings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "hii"
        return cell
    }

}

