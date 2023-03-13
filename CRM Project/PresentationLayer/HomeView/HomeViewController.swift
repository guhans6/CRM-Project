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
    private var events = [Event]()
    private let bookingController = BookingController()
    private let eventBookingController = EventBookingController()
    
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
        
//        bookedTablesView.backgroundColor = .systemGray6
        bookedTablesView.rowHeight = UITableView.automaticDimension
        bookedTablesView.estimatedRowHeight = 44
        bookedTablesView.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.identifier)
        
        bookedTablesView.backgroundColor = .background
        bookedTablesView.layer.cornerRadius = 10
        bookedTablesView.clipsToBounds = true
        
        bookedTablesView.rowHeight = view.frame.height / 15
        
        NSLayoutConstraint.activate([
            bookedTablesView.topAnchor.constraint(equalTo: datePicker.bottomAnchor ,constant: 10),
            bookedTablesView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.98),
            bookedTablesView.heightAnchor.constraint(equalToConstant: view.frame.height / 2.0),
            bookedTablesView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension HomeViewController {
    
    private func getBookedTablesFor(date: Date) {
        
        bookingController.getAvailableTablesFor(date: date,
                                                time: nil)
        { [weak self] tables, reservationIds in
            
//            self?.bookedTablesView.showLoadingIndicator()
            self?.tables = tables[1]

            if self?.tables.count ?? 0 > 0 {
                
//                self?.bookedTablesView.hideLoadingIndicator()
                
            }

            self?.bookedTablesView.reloadData()
        }
        
        eventBookingController.getEventsFor(date: date) { events in
            
            self.events = events
            self.bookedTablesView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 && tables.count > 0 {
            return "Booked Tables"
        } else if section == 1 && events.count > 0 {
            
            return "Events Happening"
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tables.isEmpty && events.isEmpty {
            
            self.bookedTablesView.setEmptyView(title: "No Activities for Today", message: "")
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
            
            if !tables.isEmpty {
                
                cell.label.text = tables[indexPath.row].name

            } else {
                
                cell.label.text = "No table Booked for this Day"
            }
        } else {
            
            if !events.isEmpty {
                
                cell.label.text = events[indexPath.row].name
            } else {
                
                cell.label.text = "No Events for this Day"
            }
        }
        cell.backgroundColor = .systemGray6
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
