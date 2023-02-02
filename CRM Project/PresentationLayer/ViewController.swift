//
//  ViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 18/01/23.
//

import UIKit
import WebKit
import SafariServices

class ViewController: UIViewController {
    
    private let openLinkButton = UIButton()
    private var isLoggedIn: Bool = false
    
    private let registerURLString: String = "https://accounts.zoho.in/oauth/v2/auth?scope=ZohoCRM.settings.ALL,ZohoCRM.users.ALL,ZohoCRM.modules.ALL&client_id=1000.CCNCZ0VYDA4LNN6YCJIUBKO7WA8ZED&response_type=code&access_type=offline&redirect_uri=https://guhans6.github.io/logIn-20611/"
    
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
        view.backgroundColor = .systemPink
        
        configureOpenLinkButton()
    }
    
    private func configureOpenLinkButton() {
        view.addSubview(openLinkButton)
        openLinkButton.translatesAutoresizingMaskIntoConstraints = false
        openLinkButton.setTitle("Open Website", for: .normal)
        openLinkButton.setTitleColor(.white, for: .normal)
        openLinkButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
        openLinkButton.addTarget(self, action: #selector(didTapOpenLinkButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            openLinkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openLinkButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        //        KeyChainController().getAccessToken()
    }
    
    @objc private func didTapOpenLinkButton() {
        
//        let navController = UINavigationController(rootViewController: WebViewController())
//        navController.modalPresentationStyle = .fullScreen
//        self.present(navController, animated: true)
        print(KeyChainController().getClientId())
        print(KeyChainController().getClientSecret())
    }
}

