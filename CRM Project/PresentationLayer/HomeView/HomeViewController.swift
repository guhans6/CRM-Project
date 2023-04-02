//
//  LoggedInViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 25/01/23.
//

import UIKit

class HomeViewController: UIViewController {
        
    private let datePicker = UIDatePicker()
    private let dateResetButton = UIButton()
    private let activitiesTableView = UITableView(frame: .zero, style: .insetGrouped)
    private var lastPickedDate = Date()
    private let mainTabBarController = UITabBarController()
    
    private var todayDate: String {
        return DateFormatter.formattedString(from: Date(), format: "yyyy-MM-dd")
    }
    
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
        datePicker.date = lastPickedDate
        datePickerValueChanged()
        navigationController?.navigationBar.prefersLargeTitles = true
        getBookedTablesFor(date: lastPickedDate)
    }
    
    private func configureUI() {
        
        configureDateResetButton()
        configureDatePicker()
        configureBookedTablesView()
        
        getBookedTablesFor(date: Date())
    }
    
    private func configureDateResetButton() {
            
        view.addSubview(dateResetButton)
        dateResetButton.translatesAutoresizingMaskIntoConstraints = false
        
        dateResetButton.setTitle("Today", for: .normal)
        dateResetButton.setTitleColor(.systemBlue, for: .normal)
        dateResetButton.titleLabel?.font = .systemFont(ofSize: 15)
        dateResetButton.addTarget(self, action: #selector(resetDateButtonTapped), for: .touchUpInside)
        dateResetButton.isHidden = true
        
        NSLayoutConstraint.activate([
            dateResetButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dateResetButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
    }
    
    @objc private func resetDateButtonTapped() {
        
        datePicker.date = Date()
        dateResetButton.isHidden = true
        getBookedTablesFor(date: datePicker.date)
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
            datePicker.topAnchor.constraint(equalTo: dateResetButton.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    @objc private func datePickerValueChanged() {
        
        let formattedDate = DateFormatter.formattedString(from: datePicker.date, format: "yyyy-MM-dd")
        if formattedDate == todayDate {
            dateResetButton.isHidden = true
        } else {
            dateResetButton.isHidden = false
        }
        getBookedTablesFor(date: datePicker.date)
    }

    private func configureBookedTablesView() {
        
        view.addSubview(activitiesTableView)
        activitiesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        activitiesTableView.delegate = self
        activitiesTableView.dataSource = self
        
        activitiesTableView.rowHeight = UITableView.automaticDimension
        activitiesTableView.estimatedRowHeight = 44
        
        activitiesTableView.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.identifier)
        
        activitiesTableView.layer.cornerRadius = 10
        activitiesTableView.clipsToBounds = true
        activitiesTableView.backgroundColor = .systemGray6
        
        NSLayoutConstraint.activate([
            activitiesTableView.topAnchor.constraint(equalTo: datePicker.bottomAnchor ,constant: 10),
            activitiesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            activitiesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            activitiesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureTabBarController() {
        
        
    }
}

extension HomeViewController {
    
    private func getBookedTablesFor(date: Date) {
        
        activitiesTableView.showLoadingIndicator()
        bookingController
            .getAvailableTablesFor(date: date, time: nil) { [weak self] tables, reservationIds in
                
                self?.activitiesTableView.showLoadingIndicator()
                self?.tables = tables[1]
                self?.reservationIds = reservationIds
                
                if self?.tables.count ?? 0 > 0 {
                    
                    self?.activitiesTableView.hideLoadingIndicator()
                }
                
                self?.activitiesTableView.reloadData()
            }
        
        eventBookingController.getEventsFor(date: date) { [weak self] events in
            
            self?.events = events
            self?.activitiesTableView.reloadData()
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
            self.activitiesTableView.setEmptyView(title: noActivitiesString, message: "", image: UIImage(named: "calendar"))
            return 0
        } else {
            
            self.activitiesTableView.restore()
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
        cell.backgroundColor = .background
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
            let reservationId = reservationIds[indexPath.row]
            let recordInfoVc = RecordInfoTableViewController(recordModule: "Reservations", recordId: reservationId, title: "Reservation Details")
            
            if let sheetController = recordInfoVc.sheetPresentationController {
                
                sheetController.detents = [.medium(), .large()]
                sheetController.prefersGrabberVisible = true
            }
            present(recordInfoVc, animated: true)
        }
    }
}
