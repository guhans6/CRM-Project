//
//  TableBookingViewController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 23/02/23.
//

import UIKit
class TableBookingViewController: UIViewController {
    
    private let bookingViewPresenter = TableBookingViewPresenter()
    private lazy var formVC = FormTableViewController(moduleApiName: "Reservations")
    
    private var tables = [[Table]]()
    
    private lazy var noDataView = UIView()
    let label = UILabel()
    private let tableView = UITableView()
    
    private let datePickerView = DatePickerTableHeaderView()
    private let myPickerVC = MyPickerViewController()
    lazy var selectedDate: Date = Date()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formVC.delegate = myPickerVC.self
        configureTableView()
        configureUI()
        
//        configureNoDataView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    
    private func configureUI() {
        
        view.backgroundColor = .systemBackground
        
//        let rightBarButton = UIBarButtonItem(title: "Pick Date", style: .plain, target: self, action: #selector(showDatePicker))
//        navigationItem.rightBarButtonItem = rightBarButton
        getTablesFor(date: Date())
        configurePickerView()
    }
    
    private func configurePickerView() {
        
        myPickerVC.modalPresentationStyle = .pageSheet
        myPickerVC.delegate  = self
        
        if let sheet = myPickerVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            sheet.prefersEdgeAttachedInCompactHeight = true
        }
    }
    
    @objc private func showDatePicker() {
        
        configurePickerView()
        myPickerVC.showView(viewType: .dateView)
        
        present(myPickerVC, animated: true, completion: nil)

    }
    
    @objc private func showTimePicker() {
        
        
        configurePickerView()
        myPickerVC.showView(viewType: .tableView)
        
        present(myPickerVC, animated: true, completion: nil)
    }
    
    private func configureHeaderView() -> DatePickerTableHeaderView {
        
        datePickerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        datePickerView.dateDisplayButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        datePickerView.timeDisplayButton.addTarget(self, action: #selector(showTimePicker), for: .touchUpInside)
        
        return datePickerView
    }
    
    private func configureTableView() {
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .tableViewSeperator
        
        tableView.tableHeaderView = configureHeaderView()

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
        label.text = "No tables available Add a new Table in Modules to continue"
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
            
            let table = tables[0][indexPath.row]
            
            
            var record = [(String, Any)]()
            
            let dateFormat = "dd-MM-yyyy"
            let lastPickedDate = myPickerVC.getPickedDate()
            
//            let dateString = dateFormatter.string(from: myPickerVC.getLastPickedDate())
            let dateString = DateFormatter.formattedString(from: lastPickedDate, format: dateFormat)
            
            let pickedTime = myPickerVC.getPickedTime()
            
//            let bookingTable = table.id.appending(",").appending(table.name) 
            record.append(("Booking_Table", [table.id, table.name]))
            record.append(("Booking_Date", dateString))
            record.append(("Pick_List_1", pickedTime))
            
            formVC.setUpCellsForEditing(recordid: nil, recordData: record, recordState: .editAndUserInteractionDisabled)
            
            navigationController?.pushViewController(formVC, animated: true)
        }
    }
    
}

extension TableBookingViewController: PickerViewDelegate {
    
    func dateAndTime(date: Date, time: String) {
        self.getTablesFor(date: date)
        
        let dateString = DateFormatter.formattedString(from: date, format: "dd-MM-yyyy")
        
        self.datePickerView.dateDisplayButton.setTitle(dateString, for: .normal)
        self.datePickerView.timeDisplayButton.setTitle(time, for: .normal)
    }

}
