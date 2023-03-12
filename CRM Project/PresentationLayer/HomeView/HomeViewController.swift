//
//  LoggedInViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 25/01/23.
//

import UIKit

class HomeViewController: UIViewController {
        
    private let datePicker = UIDatePicker()
    
    private let bookedTablesView = UITableView(frame: .zero, style: .insetGrouped)
    private let cellIdentifier = "cell"
    
    private var tables = [Table]()
    private let bookingController = BookingController()
    
    deinit {
        print("Login deinitialized")
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "Home"

        configureUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureUI() {
        
        getBookedTablesFor(date: Date())
        configureDatePicker()
        configureBookedTablesView()
        NetworkController().generateAuthToken()
    }
    
    
    private func configureDatePicker() {
        
        view.addSubview(datePicker)
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = .background
        
        datePicker.layer.cornerRadius = 20
        datePicker.clipsToBounds = true
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            datePicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.97),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func datePickerValueChanged() {
        
        getBookedTablesFor(date: datePicker.date)
    }
    
    private func configureBookedTablesView() {
        
        view.addSubview(bookedTablesView)
        bookedTablesView.translatesAutoresizingMaskIntoConstraints = false
        
        bookedTablesView.delegate = self
        bookedTablesView.dataSource = self
        bookedTablesView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        bookedTablesView.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.identifier)
        
        bookedTablesView.backgroundColor = .background
        bookedTablesView.layer.cornerRadius = 10
        bookedTablesView.clipsToBounds = true
        
        bookedTablesView.rowHeight = view.frame.height / 15
        
        NSLayoutConstraint.activate([
            bookedTablesView.topAnchor.constraint(equalTo: datePicker.bottomAnchor ,constant: 10),
            bookedTablesView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.98),
            bookedTablesView.heightAnchor.constraint(equalToConstant: view.frame.height / 2.8),
            bookedTablesView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension HomeViewController {
    
    private func getBookedTablesFor(date: Date) {
        
        bookingController
            .getAvailableTablesFor(date: date, time: nil) { [weak self] tables, reservationIds in
            
            self?.bookedTablesView.showLoadingIndicator()
            self?.tables = tables[1]

            if self?.tables.count ?? 0 > 0 {
                
                self?.bookedTablesView.hideLoadingIndicator()
                
            } else {
                
                self?.bookedTablesView.setEmptyView(title: "No Tables Booked For Today", message: "")
            }
            self?.bookedTablesView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tables.count > 0 {
            return "Booked Tables"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier) as! LabelTableViewCell
        
        let table = tables[indexPath.row]
        
        cell.label.text = table.name
        return cell
    }
}
