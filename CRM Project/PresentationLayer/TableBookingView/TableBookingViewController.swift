//
//  TableBookingViewController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 23/02/23.
//

import UIKit

class TableBookingViewController: UIViewController {
    
    private let datePicker = UIDatePicker()
    private let tableView = UITableView()
    
    private var availableTables: [Table] = [] // assuming you have a model called Table
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDatePicker()
        configureTableView()
        
        // add constraints for subviews
        view.backgroundColor = .systemBackground
        
        
        
    }
    
    private func configureDatePicker() {
        
        datePicker.datePickerMode = .date
    }
    
    private func configureTableView() {
        
        
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = DatePickerTableHeaderView()
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        loadData()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadData() {
        
        availableTables = [
                    Table(name: "aa",number: 1, capacity: 4, isAvailable: true),
                    Table(name: "bb",number: 2, capacity: 2, isAvailable: false),
                    Table(name: "c",number: 3, capacity: 6, isAvailable: true),
                    Table(name: "d",number: 4, capacity: 8, isAvailable: true),
                    Table(name: "e",number: 5, capacity: 2, isAvailable: false)
                ]
        tableView.reloadData()
    }
}

extension TableBookingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableTables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let table = availableTables[indexPath.row]
        cell.textLabel?.text =  table.name// assuming Table model has a name property
        return cell
    }
}


struct Table {
    let name: String
    let number: Int
    let capacity: Int
    let isAvailable: Bool
}
