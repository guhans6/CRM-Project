//
//  TableBookingViewController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 23/02/23.
//

import UIKit

class TableBookingViewController: UIViewController {
    
    private let bookingViewController = BookingController()
    private let module = "Reservations"
    private lazy var formVC = FormTableViewController(moduleApiName: module)
    
    private var tables = [[Table]]()
    private var reservationIds = [String]()
    
    private lazy var noDataView = UIView()
    let label = UILabel()
    private lazy var tableView = UITableView(frame: .zero , style: .insetGrouped)
    
    private let datePickerView = DateAndTimeHeaderView()
    private let myPickerVC = PickerViewController()
    
    // MARK: MAKE IT A COMPUTED PROPERTY
    lazy var selectedDate: Date = Date()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Book Table"
        formVC.delegate = myPickerVC.self
        configureTableView()
        configureUI()
    }
    
    private func configureUI() {
        
        view.backgroundColor = .systemBackground
        
        getTablesFor(date: Date(), time: myPickerVC.getPickedTime())
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
    
    private func configureHeaderView() -> DateAndTimeHeaderView {
        
        datePickerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        datePickerView.dateDisplayButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        datePickerView.timeDisplayButton.addTarget(self, action: #selector(showTimePicker), for: .touchUpInside)
        
        return datePickerView
    }
    
    private func configureTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .tableViewSeperator
        tableView.tableHeaderView = configureHeaderView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.identifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func getTablesFor(date: Date, time: String) {
        
        bookingViewController
            .getAvailableTablesFor(date: date, time: time) { allTables, reservationIds in
                
                self.selectedDate = date
                self.tables = allTables
                self.reservationIds = reservationIds
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
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as! LabelTableViewCell
        
        
        let labelText = tables[indexPath.section][indexPath.row].name
        cell.configureCellWith(text: labelText)
        
        if indexPath.section == 1 {
            cell.accessoryType = .detailButton
        }
        
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
        let table = tables[0][indexPath.row]
        
        if indexPath.section == 0 {
            
            var record = [(String, Any)]()
            
            let dateFormat = "dd-MM-yyyy"
            let lastPickedDate = myPickerVC.getPickedDate()
            
            let dateString = DateFormatter.formattedString(from: lastPickedDate, format: dateFormat)
            
            let pickedTime = myPickerVC.getPickedTime()
            
            record.append(("Booking_Table", [table.id, table.name]))
            record.append(("Booking_Date", dateString))
            record.append(("Pick_List_1", pickedTime))
            
            formVC.setUpCellsForEditing(recordid: nil, recordData: record, recordState: .editAndUserInteractionDisabled)
            
            navigationController?.pushViewController(formVC, animated: true)
            
        } else if indexPath.section == 1 {

            let reservationId = reservationIds[indexPath.row]
            let recordInfoVC = RecordInfoTableViewController(recordModule: "Reservations",
                                                             recordId: reservationId)
            recordInfoVC.title = "Booking Details"
            if let formSheet = recordInfoVC.sheetPresentationController {
                formSheet.detents = [.medium(), .large()]
//                formSheet.prefersGrabberVisible = true
            }
            
            present(recordInfoVC, animated: true)
        }
    }
    
}

extension TableBookingViewController: PickerViewDelegate {
    
    func dateAndTime(date: Date, time: String) {
        
        self.getTablesFor(date: date, time: myPickerVC.getPickedTime())
        
        let dateString = DateFormatter.formattedString(from: date, format: "dd-MM-yyyy")
        
        self.datePickerView.dateDisplayButton.setTitle(dateString, for: .normal)
        self.datePickerView.timeDisplayButton.setTitle(time, for: .normal)
    }
    
}

