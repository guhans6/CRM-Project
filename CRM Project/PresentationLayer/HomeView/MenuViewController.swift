//
//  MenuVC.swift
//
//  Created by guhan-pt6208 on 25/02/23.
//

import UIKit

protocol MenuViewDelegate: AnyObject {
    
    func didSelectRow(row: Int, title: String) -> Void
}

class MenuViewController: UIViewController {
    
    private let headerView = UIView()
    private let tableView = UITableView()
    private let userController: UserDetailControllerContract = UserDetailController()
    
    private lazy var menuOptions = [
        "Table Booking".localized(),
        "Modules".localized(),
        "Generate Auth Token".localized()
    ]
    private lazy var nameLabel = UILabel()
    private lazy var emailLabel = UILabel()
    weak var delegate: MenuViewDelegate?
    
    private let darkModeSwitch = UISwitch()
    private lazy var logoutButton = UIButton()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        getCurrentUser()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Menu".localized()
        view.backgroundColor = .systemGray6
        navigationController?.navigationBar.prefersLargeTitles = true
        
        confiureTableHeaderView()
        configureTableView()
        configureLogoutButton()
    }
    
    private func confiureTableHeaderView() {
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.backgroundColor = .tableSelect

        NSLayoutConstraint.activate([
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            headerView.heightAnchor.constraint(equalToConstant: 90),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.bottomAnchor.constraint(equalTo: headerView.topAnchor, constant: 90)
        ])
        
//        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.font = .systemFont(ofSize: 25, weight: .semibold)

        headerView.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 17),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            nameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: headerView.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        emailLabel.adjustsFontForContentSizeCategory  = true
        emailLabel.font = .systemFont(ofSize: 17)
        emailLabel.textColor = .label
        headerView.addSubview(emailLabel)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerView.safeAreaLayoutGuide.trailingAnchor),
            emailLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -3)
        ])
    }
    
    private func configureTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray6
        tableView.separatorColor = .tableViewSeperator
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.identifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
        ])
    }

    private func configureLogoutButton() {
        
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        logoutButton.setTitle("Logout".localized(), for: .normal)

        logoutButton.setTitleColor(.label, for: .normal)
        
        let logoutButtonFont: UIFont = .systemFont(ofSize: 25, weight: .semibold)
        let fontMetrics = UIFontMetrics(forTextStyle: .headline)
        logoutButton.titleLabel?.font = fontMetrics.scaledFont(for: logoutButtonFont)
        logoutButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        logoutButton.backgroundColor = .systemGray6
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            logoutButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            logoutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
        ])
        
    }
    
    
    @objc private func logoutButtonTapped() {
        
        UserDefaultsManager.shared.setLogIn(equalTo: false)
        dismiss(animated: true)
    }
    
    private func getCurrentUser() {
        
        userController.getUserDetails { currentUser in
            self.nameLabel.text = currentUser?.fullName
            self.emailLabel.text = currentUser?.email
            self.tableView.reloadData()
        }
    }
    
    private func configureDarkModeSwitch() {
        
        view.addSubview(darkModeSwitch)
        darkModeSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        darkModeSwitch.addTarget(self, action: #selector(darkModeButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            darkModeSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
    
    @objc private func darkModeButtonTapped() {
        
        
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                if darkModeSwitch.isOn {
                    window.overrideUserInterfaceStyle = .dark
                } else {
                    window.overrideUserInterfaceStyle = .light
                }
            }
        }
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as! LabelTableViewCell
        
        cell.label.text = menuOptions[indexPath.row]
        cell.backgroundColor = .systemGray6
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = menuOptions[indexPath.row]
        delegate?.didSelectRow(row: indexPath.row, title: title)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
