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
    private lazy var tableView = UITableView(frame: .zero , style: .insetGrouped)
    
    private let datePickerView = DateAndTimeHeaderView()
    private let pickerVC = PickerViewController(headerTitle: "Pick Time")
    private var lastPickedDate = Date()
    private var lastPickedTime = "Breakfast"
    
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
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        getTablesFor(date: lastPickedDate, time: lastPickedTime)
    }
    
    private func configureUI() {
        
        view.backgroundColor = .systemGray6
        
        formVC.delegate = pickerVC.self
        configureHeaderView()
        configureTableView()
        getTablesFor(date: Date(), time: pickerVC.getPickedTime())
        configurePickerView()
    }
    
    private func configurePickerView() {
        
        pickerVC.modalPresentationStyle = .pageSheet
        pickerVC.delegate  = self
        
        if let sheet = pickerVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            sheet.prefersEdgeAttachedInCompactHeight = true
        }
    }
    
    @objc private func showDatePicker() {
        
        configurePickerView()
        pickerVC.showView(viewType: .dateView)
        
        present(pickerVC, animated: true, completion: nil)
    }
    
    @objc private func showTimePicker() {
        
        configurePickerView()
        pickerVC.showView(viewType: .tableView)
        
        present(pickerVC, animated: true, completion: nil)
    }
    
    private func configureHeaderView() {
        
        view.addSubview(datePickerView)
        
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        datePickerView.backgroundColor = .systemGray6
        
        datePickerView.dateDisplayButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        datePickerView.timeDisplayButton.addTarget(self, action: #selector(showTimePicker), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            datePickerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            datePickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datePickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            datePickerView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.separatorColor = .tableViewSeperator
        tableView.backgroundColor = .systemGray6

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.identifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: datePickerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func getTablesFor(date: Date, time: String) {
        
        lastPickedTime = time
        lastPickedDate = date
        tableView.showLoadingIndicator()
        bookingViewController
            .getAvailableTablesFor(date: date, time: time) { [weak self] allTables, reservationIds in
                
                self?.selectedDate = date
                self?.tables = allTables
                self?.reservationIds = reservationIds
                self?.tableView.reloadData()
                self?.tableView.hideLoadingIndicator()
            }
    }
    
}

extension TableBookingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tables.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
        cell.backgroundColor = .systemBackground
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
            noDataView.setMessage("All tables are booked for the day !")
            return noDataView
            
        } else if section == 1 && tables[section].isEmpty {
            
            let noDataView = NoDataView()
            noDataView.setMessage("No Table is Booked for the Day")
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
            let lastPickedDate = pickerVC.getPickedDate()
            
            let dateString = DateFormatter.formattedString(from: lastPickedDate, format: dateFormat)
            
            let pickedTime = pickerVC.getPickedTime()
            
            record.append(("Booking_Table", [table.id, table.name]))
            record.append(("Booking_Date", dateString))
            record.append(("Pick_List_1", pickedTime))
            
            formVC.setUpCellsForEditing(recordid: nil, recordData: record, recordState: .editAndUserInteractionDisabled)
            
            let navVc = UINavigationController(rootViewController: formVC)
            navVc.modalPresentationStyle = .fullScreen
            present(navVc, animated: true)
            
        } else if indexPath.section == 1 {

            let reservationId = reservationIds[indexPath.row]
            let recordInfoVC = RecordInfoTableViewController(recordModule: "Reservations",
                                                             recordId: reservationId)
            recordInfoVC.title = "Booking Details"
            if let formSheet = recordInfoVC.sheetPresentationController {
                formSheet.detents = [.medium(), .large()]
                formSheet.prefersGrabberVisible = true
            }
            
            present(recordInfoVC, animated: true)
        }
    }
    
}

extension TableBookingViewController: PickerViewDelegate {
    
    func pickerViewData(datePickerDate: Date, tableviewSelectedRow: String) {
        
        self.getTablesFor(date: datePickerDate, time: pickerVC.getPickedTime())
        
        let dateString = DateFormatter.formattedString(from: datePickerDate, format: "dd-MM-yyyy")
        
        self.datePickerView.dateDisplayButton.setTitle(dateString, for: .normal)
        self.datePickerView.timeDisplayButton.setTitle(tableviewSelectedRow, for: .normal)
    }
    
}

