//
//  MenuVC.swift
//
//  Created by guhan-pt6208 on 25/02/23.
//

import UIKit

class MenuVC: UIViewController {
    
    let tableView = UITableView()
    lazy var menuOptions = ["Table Booking", "Employee Management", "Modules", "Generate Auth Token"]
    lazy var nameLabel = UILabel()
    lazy var emailLabel = UILabel()
    
    let darkModeSwitch = UISwitch()
    lazy var logoutButton = UIButton()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        getCurrentUser()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Menu"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureTableView()
        configureLogoutButton()
    }
    
    private func configureTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray6
        tableView.separatorColor = .tableViewSeperator
        tableView.tableHeaderView = confiureTableHeaderView()
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
        ])
    }
    
    private func confiureTableHeaderView() -> UIView {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 90))
        headerView.backgroundColor = .tableSelect
        
        nameLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        nameLabel.text = "Guhan"
        headerView.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: headerView.leadingAnchor, constant: 30),
            
        ])
        
        emailLabel.text = "guhan@gmail.com"
        emailLabel.textAlignment = .center
        emailLabel.font = .preferredFont(forTextStyle: .subheadline)
        emailLabel.textColor = .label
        headerView.addSubview(emailLabel)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
        ])
        
        return headerView
    }
    
    private func configureLogoutButton() {
        
        //        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        //        footerView.backgroundColor = .orange
        
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        logoutButton.setTitleColor(.label, for: .normal)
        //        logoutButton.setImage(UIImage(systemName: "power"), for: .normal)
        
        view.addSubview(logoutButton)
        view.bringSubviewToFront(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
        ])
        
    }
    
    private func getCurrentUser() {
        
        UserDetailController().getUserDetails { currentUser in
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

extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = menuOptions[indexPath.row]
        cell.backgroundColor = .systemGray6
        
        //        print(cell.textLabel?.font)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let text = tableView.cellForRow(at: indexPath)?.textLabel?.text
        

        switch text {
        case "Modules":
        
            let moduleTableVC = ModulesTableViewController()
            let _ = UINavigationController(rootViewController: moduleTableVC)
            
            moduleTableVC.modalPresentationStyle = .fullScreen
            
            navigationController?.pushViewController(moduleTableVC, animated: true)
            
        case "Table Booking":
            
            let tableBookingVC = TableBookingViewController()
            navigationController?.pushViewController(tableBookingVC, animated: true)
        case "Generate Auth Token":
            
            NetworkController().generateAuthToken()
        default :
            
            print("No Options Selected")
        }
        
    }
}
