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
    private var reservationIds = [String]()
    private var events = [Event]()
    private let bookingController = BookingController()
    private let eventBookingController = EventBookingController()
    
    deinit {
        print("Login deinitialized")
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "Home".localized()

        configureUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureUI() {
        
        configureDatePicker()
        configureBookedTablesView()
        getBookedTablesFor(date: Date())
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
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
        
        bookedTablesView.rowHeight = UITableView.automaticDimension
        bookedTablesView.estimatedRowHeight = 44
        
        bookedTablesView.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.identifier)
        
        
        bookedTablesView.layer.cornerRadius = 10
        bookedTablesView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            bookedTablesView.topAnchor.constraint(equalTo: datePicker.bottomAnchor ,constant: 10),
            bookedTablesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bookedTablesView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bookedTablesView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HomeViewController {
    
    private func getBookedTablesFor(date: Date) {
        
        bookingController
            .getAvailableTablesFor(date: date, time: nil) { [weak self] tables, reservationIds in
                
                self?.bookedTablesView.showLoadingIndicator()
                self?.tables = tables[1]
                self?.reservationIds = reservationIds
                
                if self?.tables.count ?? 0 > 0 {
                    
                    self?.bookedTablesView.hideLoadingIndicator()
                }
                
                self?.bookedTablesView.reloadData()
            }
        
        eventBookingController.getEventsFor(date: date) { [weak self] events in
            
            self?.events = events
            self?.bookedTablesView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 && tables.count > 0 {
            return "Booked Tables".localized()
        } else if section == 1 && events.count > 0 {
            
            return "Events Happening".localized()
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tables.isEmpty && events.isEmpty {
            
            let noActivitiesString = "No Activities for Today".localized()
            self.bookedTablesView.setEmptyView(title: noActivitiesString, message: "")
            return 0
        } else {
            
            self.bookedTablesView.restore()
            if section == 0 {
                
                return tables.count == 0 ? 1 : tables.count
            } else {
                
                return events.count == 0 ? 1 : events.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier) as! LabelTableViewCell
        
        if indexPath.section == 0 {
            
            if tables.isEmpty == false {
                
                cell.label.text = tables[indexPath.row].name

            } else {
                
                cell.label.text = "No table Booked for this Day".localized()
            }
        } else {
            
            if events.isEmpty == false {
                
                cell.label.text = events[indexPath.row].name
            } else {
                
                cell.label.text = "No Events for this Day".localized()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let reservationId = reservationIds[indexPath.row]
            let recordInfoVc = RecordInfoTableViewController(recordModule: "Reservations", recordId: reservationId)
            
            present(recordInfoVc, animated: true)
        }
    }
}
