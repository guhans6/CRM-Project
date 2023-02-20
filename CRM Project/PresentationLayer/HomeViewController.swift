//
//  LoggedInViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 25/01/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    var presenter: HomeViewPresenterContract? = HomeViewPresenter()
    
    let welcomeUserLabel = UILabel()
    let logoutButton = UIButton()
    let requestButton = UIButton()
    let generateAuthTokenButton = UIButton()
    let modulesViewButton = UIButton()
    
    
    
    deinit {
        print("Login deinitialized")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        presenter?.generateAuthToken()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func configureUI() {
        configureLogoutButtion()
        configureRequestButton()
        configureGenerateAuthTokenButton()
        configureWelcomeUserlabel()
        configureFormViewButton()
    }
    
    private func configureWelcomeUserlabel() {
        view.addSubview(welcomeUserLabel)
        welcomeUserLabel.translatesAutoresizingMaskIntoConstraints = false
        
        welcomeUserLabel.text = "Welcome "
        welcomeUserLabel.textAlignment = .center
        welcomeUserLabel.textColor = .white
        welcomeUserLabel.font = .systemFont(ofSize: 20, weight: .medium)
        
        NSLayoutConstraint.activate([
            welcomeUserLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeUserLabel.centerYAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -70),
            
        ])
    }
    
    private func configureLogoutButtion() {
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false

        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            
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
        requestButton.setTitleColor(.white, for: .normal)
        requestButton.addTarget(self, action: #selector(makeRequestButtonTapped), for: .touchUpInside)
        requestButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        NSLayoutConstraint.activate([
            requestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            requestButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            
        ])
    }
    
    @objc private func makeRequestButtonTapped() {
        
    }

    private func configureGenerateAuthTokenButton() {
        view.addSubview(generateAuthTokenButton)
        generateAuthTokenButton.translatesAutoresizingMaskIntoConstraints = false

        generateAuthTokenButton.setTitle("Generate new Token", for: .normal)
        generateAuthTokenButton.setTitleColor(.white, for: .normal)
        generateAuthTokenButton.addTarget(self, action: #selector(generateTokenButtonTapped), for: .touchUpInside)
        generateAuthTokenButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        NSLayoutConstraint.activate([
            generateAuthTokenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            generateAuthTokenButton.centerYAnchor.constraint(equalTo: requestButton.bottomAnchor, constant: 50),
            
        ])
    }
    
    @objc private func generateTokenButtonTapped() {
        presenter?.generateAuthToken()
    }
    
    private func configureFormViewButton() {
        view.addSubview(modulesViewButton)
        modulesViewButton.translatesAutoresizingMaskIntoConstraints = false

        modulesViewButton.setTitle("View Modules", for: .normal)
        modulesViewButton.setTitleColor(.white, for: .normal)
        modulesViewButton.addTarget(self, action: #selector(formViewButtonTapped), for: .touchUpInside)
        modulesViewButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        NSLayoutConstraint.activate([
            modulesViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modulesViewButton.centerYAnchor.constraint(equalTo: generateAuthTokenButton.bottomAnchor, constant: 30),
            
        ])
    }
    
    @objc private func formViewButtonTapped() {
        let moduleTableVC = ModulesTableViewController()
        let _ = UINavigationController(rootViewController: moduleTableVC)
        navigationController?.pushViewController(moduleTableVC, animated: true)
//        presenter?.navigateToModule()
    }
}