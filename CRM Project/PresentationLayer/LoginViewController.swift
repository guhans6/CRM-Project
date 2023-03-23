//
//  ViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 18/01/23.
//

import UIKit
class LoginViewController: UIViewController {
    
    private let loginButton = UIButton()
    private var isLoggedIn: Bool = false
    
    deinit {
        print("Main View Controller Deinitialized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaultsManager.shared.isUserLoggedIn() {
            dismiss(animated: true)
        }
    }
    
    private func configureUI() {
        
        view.backgroundColor = .systemBlue
        
        configureOpenLinkButton()
    }
    
    private func configureOpenLinkButton() {
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false

        loginButton.backgroundColor = .systemBlue
        loginButton.setTitle("Login".localized(), for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
        loginButton.addTarget(self, action: #selector(didTapOpenLinkButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
        ])
    }
    
    @objc private func didTapOpenLinkButton() {
        
        if NetworkMonitor.shared.isConnected {
            let navController = UINavigationController(rootViewController: WebViewController())
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        } else {
            
            let alertController = UIAlertController(title: "Network Connection Required", message: "Please connect to a network to continue", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default)

            alertController.addAction(okAction)

            self.present(alertController, animated: true, completion:nil)

        }
    }
}
