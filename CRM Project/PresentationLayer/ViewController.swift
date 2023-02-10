//
//  ViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 18/01/23.
//

import UIKit
class ViewController: UIViewController {
    
    private let openLinkButton = UIButton()
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
    }
    
    @objc private func didTapOpenLinkButton() {
        
        let navController = UINavigationController(rootViewController: WebViewController())
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
        print(KeyChainController().getClientId())
        print(KeyChainController().getClientSecret())
//        KeyChainController().saveClientIdAndSecret()
    }
}
