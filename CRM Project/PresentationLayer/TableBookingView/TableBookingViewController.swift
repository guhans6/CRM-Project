//
//  TableBookingViewController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 23/02/23.
//

import UIKit

class TableBookingViewController: UIViewController {
    
    private let bookingViewPresenter = TableBookingViewPresenter()
    private var tables = [[Table]]()
    private lazy var noDataView = UIView()
    let label = UILabel()
    
    private let tableView = UITableView()
    private let datePickerView = DatePickerTableHeaderView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDatePickerView()
        configureTableView()
//        configureNoDataView()
        
        // add constraints for subviews
        view.backgroundColor = .systemBackground
        
        
        
    }
    
    private func configureDatePickerView() {
        view.addSubview(datePickerView)
        datePickerView.datePicker.datePickerMode = .date
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
//        datePickerView.datePicker.minimumDate = Date()
        datePickerView.okButton.addTarget(self, action: #selector(datePickerValueChanged), for: .touchUpInside)

        NSLayoutConstraint.activate([
            datePickerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            datePickerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            datePickerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            datePickerView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func datePickerValueChanged() {
        
        bookingViewPresenter.getTablesIn(date: datePickerView.datePicker.date) { allTables in
            self.tables = allTables
            self.tableView.reloadData()
        }
    }
    
    private func configureTableView() {
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = UIColor(named: "tableViewSeperator")

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: datePickerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureNoDataView() {
        
        noDataView.frame = CGRect(x: self.tableView.center.x, y: self.tableView.center.y, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height)
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        noDataView.addSubview(label)
        
        titleLabel.centerYAnchor.constraint(equalTo: noDataView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: noDataView.centerXAnchor).isActive = true
        label.text = "No tables available"
        label.sizeToFit()
        self.tableView.backgroundView = noDataView
        self.tableView.separatorStyle = .none
        
    }
    
}

extension TableBookingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tables.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.tables[section].count
        
        let count = self.tables[section].count
        
        print(count)
        if count == 0 {
            self.tableView.setEmptyView(title: "No Tables Available", message: "")
        } else {
            self.tableView.restore()
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = tables[indexPath.section][indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      
        if section == 0 {
            return "Available Tables"
        } else {
            return "Booked Tables"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 && tables[section].isEmpty {
            
            let noDataView = NoDataView()
            noDataView.setMessage("No Table Available")
            return noDataView
            
        } else if section == 1 && tables[section].isEmpty {
  
            let noDataView = NoDataView()
            noDataView.setMessage("No Table is Booked Till Now")
            return noDataView
        }
        return nil
    }
}
