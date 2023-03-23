//
//  SplashViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 26/01/23.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let logoImageView = UIImageView(image: UIImage(named: "crm logo"))
    private lazy var splitvc = UISplitViewController(style: .doubleColumn)
    
    private lazy var menuViewController = MenuViewController()
    private lazy var homeViewController = HomeViewController()
    private lazy var loginViewController = LoginViewController()
    
    private var isMenuOpen = false
    
    var isUserLoggedIn: Bool {
        get {
            UserDefaultsManager.shared.isUserLoggedIn()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        setUpViewController()
    }
    
    func configureUI() {
        
        view.backgroundColor = .systemBackground
        configureLogoView()
        menuViewController.delegate = self
    }
    
    func configureLogoView() {
        view.addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setUpViewController() {
        
        if UserDefaultsManager.shared.isUserLoggedIn() {
            
            presentSplitView()
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

                self.loginViewController.modalPresentationStyle = .fullScreen
                self.present(self.loginViewController, animated: true)
            }
        }
    }
    
    private func presentSplitView() {
        
        let menuVC = UINavigationController(rootViewController: menuViewController)
        let homeNavigationVC = UINavigationController(rootViewController: homeViewController)
        
        splitvc.modalPresentationStyle = .fullScreen
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didTapCloseButton))
        leftSwipeGesture.direction = .left
        
        menuViewController.view.addGestureRecognizer(leftSwipeGesture)
        
        if self.traitCollection.userInterfaceIdiom == .phone {
            
            menuViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
            
            let navigationLeftButton = UIImage(systemName: "list.dash")
            homeViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: navigationLeftButton, style: .plain, target: self, action: #selector(menuButtonTapped))
        }
        
        splitvc.setViewController(menuVC, for: .primary)
        splitvc.setViewController(homeViewController, for: .secondary)
        
        present(splitvc, animated: true)
    }
    
    @objc private func menuButtonTapped() {
        
        splitvc.show(.primary)
    }
    
    @objc private func didTapCloseButton() {
        
        splitvc.show(.secondary)
        isMenuOpen = false
    }
}

extension SplashViewController: MenuViewDelegate {
    
    
    func didSelectRow(row: Int, title: String) {
        
        isMenuOpen = true
        
        switch title {
    
        case "Modules".localized():
            
            homeViewController.navigationController?.popToRootViewController(animated: true)
            let moduleTableVC = ModulesTableViewController()
            
            moduleTableVC.modalPresentationStyle = .fullScreen
            
            homeViewController.navigationController?.pushViewController(moduleTableVC, animated: true)
            didTapCloseButton()
            
        case "Table Booking".localized():
            
            homeViewController.navigationController?.popToRootViewController(animated: true)
            let tableBookingVC = TableBookingViewController()
            
            homeViewController.navigationController?.pushViewController(tableBookingVC, animated: true)
            didTapCloseButton()
        case "Generate Auth Token".localized():
            
            NetworkController().generateAuthToken()
        default :
            
            print("No Options Selected")
        }
    }
}
