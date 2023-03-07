//
//  LoggedInViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 25/01/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    private let welcomeUserLabel = UILabel()
    
    private let datePicker = UIDatePicker()
    
    private let bookedTablesView = UITableView()
    
    private var tables = [Table]()
    
    deinit {
        print("Login deinitialized")
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Home"

        configureUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureUI() {
        
        getBookedTablesFor()
        configureDatePicker()
        configureBookedTablesView()
        getBookedTablesFor()
    }
    
    
    private func configureDatePicker() {
        
        view.addSubview(datePicker)
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            datePicker.widthAnchor.constraint(equalTo: view.widthAnchor),
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
        
        NSLayoutConstraint.activate([
            bookedTablesView.topAnchor.constraint(equalTo: datePicker.bottomAnchor),
            bookedTablesView.widthAnchor.constraint(equalTo: view.widthAnchor),
            bookedTablesView.heightAnchor.constraint(equalToConstant: view.frame.height / 2)
//            bookedTablesView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HomeViewController {
    
    private func getBookedTablesFor(date: Date = Date()) {
        
        
        BookingController().getAvailableTablesFor(date: date) { [weak self] tables in
            
            self?.bookedTablesView.showLoadingIndicator()
            self?.tables = tables[0]
            if self?.tables.count ?? 0 > 0 {
                
                self?.bookedTablesView.hideLoadingIndicator()
                self?.bookedTablesView.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Booked Tables"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        print(tables.count)
        return tables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let table = tables[indexPath.row]
        
        cell.textLabel?.text = table.name
        
        return cell
    }
    
    
    
}
