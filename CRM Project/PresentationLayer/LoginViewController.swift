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
    private var hotelHubLabel = UILabel()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return .portrait
    }
    
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
        
        view.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.4588235294, blue: 0.6745098039, alpha: 1)
        
        configureImageView()
        configureOpenLinkButton()
    }
    
    
    private func configureImageView() {
        
        view.addSubview(hotelHubLabel)
        hotelHubLabel.translatesAutoresizingMaskIntoConstraints = false
        hotelHubLabel.text = "Hotel Hub"
        hotelHubLabel.textColor = .white
        hotelHubLabel.font = .systemFont(ofSize: 30, weight: .bold)
        
        NSLayoutConstraint.activate([
            
            hotelHubLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (view.frame.height / 2) / 2),
            hotelHubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureOpenLinkButton() {
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelColour = #colorLiteral(red: 0.2901960784, green: 0.4588235294, blue: 0.6745098039, alpha: 1)

        loginButton.backgroundColor = .systemBackground
        loginButton.setTitle("Login".localized(), for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
        loginButton.setTitleColor(titleLabelColour, for: .normal)
        loginButton.layer.cornerRadius = 15
        loginButton.addTarget(self, action: #selector(didTapOpenLinkButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(greaterThanOrEqualTo: hotelHubLabel.bottomAnchor),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 200)
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
