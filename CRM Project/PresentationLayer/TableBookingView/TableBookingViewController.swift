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
//    private let datePickerView = DatePickerTableHeaderView()
    lazy var myPickerVC = MyPickerViewController()
    lazy var selectedDate: Date = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
//        configureNoDataView()
        
        // add constraints for subviews
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapPickerButton))
        
        getTablesFor(date: Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        getTablesFor(date: <#T##Date#>)
    }
    
    
    @objc private func didTapPickerButton() {
        
        myPickerVC.modalPresentationStyle = .pageSheet
        myPickerVC.delegate  = self
        
        if let sheet = myPickerVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            sheet.prefersEdgeAttachedInCompactHeight = true
        }
        
        present(myPickerVC, animated: true, completion: nil)

    }
    
    private func configureTableView() {
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .tableViewSeperator

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
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
    
    private func getTablesFor(date: Date) {
        
        bookingViewPresenter.getTablesIn(date: date) { allTables in
            self.selectedDate = date
            self.tables = allTables
            self.tableView.reloadData()
        }
    }
    
}

extension TableBookingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tables.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.tables[section].count
        
        let count = self.tables[section].count
        
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
            noDataView.setMessage("All tables are booked for this day !")
            return noDataView
            
        } else if section == 1 && tables[section].isEmpty {
  
            let noDataView = NoDataView()
            noDataView.setMessage("No Table is Booked Till Now")
            return noDataView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
            let table = tables[0][indexPath.section]
            
            let formVC = FormTableViewController(module: "Reservations")
            
            let recordId = table.id
            
            var record = [(String, String)]()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            let dateString = dateFormatter.string(from: myPickerVC.getLastPickedDate())
            
//            record.append(("id" ,table.id))
            record.append(("Booking_Table", table.name))
            record.append(("Booking_Date", dateString))
            
            formVC.setUpCellsForEditing(recordid: nil, recordData: record)
            
            navigationController?.pushViewController(formVC, animated: true)
        }
        
    }
}

extension TableBookingViewController: PickerViewDelegate {
    
    func dateAndTime(date: Date, time: String) {
        self.getTablesFor(date: date)
    }

}

