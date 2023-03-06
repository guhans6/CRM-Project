//
//  LoggedInViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 25/01/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    let welcomeUserLabel = UILabel()
    let requestButton = UIButton()
    let generateAuthTokenButton = UIButton()
    
    private let datePicker = UIDatePicker()
    
    lazy var textColour = UIColor(named: "TextColour")
    
    let bookedTables = UITableView()
    
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
//        presenter?.generateAuthToken()
    }
    
    private func configureUI() {
        
        configureDatePicker()
        
    }
    
    
    private func configureDatePicker() {
        
        view.addSubview(datePicker)
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            datePicker.widthAnchor.constraint(equalTo: view.widthAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureBookedTablesView() {
        
        view.addSubview(bookedTables)
        
        bookedTables.delegate = self
        
        NSLayoutConstraint.activate([
            bookedTables.topAnchor.constraint(equalTo: datePicker.topAnchor),
            bookedTables.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    @objc private func logoutButtonTapped() {
        UserDefaultsManager.shared.setLogIn(equalTo: false)
        dismiss(animated: true)
    }
    
    private func configureRequestButton() {
        view.addSubview(requestButton)
        requestButton.translatesAutoresizingMaskIntoConstraints = false

        
        requestButton.setTitle("Make Request", for: .normal)
        requestButton.setTitleColor(.label, for: .normal)
        requestButton.addTarget(self, action: #selector(makeRequestButtonTapped), for: .touchUpInside)
        requestButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        NSLayoutConstraint.activate([
            requestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            requestButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            
        ])
    }
    
    @objc private func makeRequestButtonTapped() {
        
//        self.navigationController?.pushViewController(TableBookingViewController(), animated: true)
//        ModulesNetworkService().getAllModules()
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "Table"
        
        return cell
    }
    
    
    
}
