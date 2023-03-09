//
//  SplashViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 26/01/23.
//

import UIKit

class SplashViewController: UIViewController {
    
    let logoImageView = UIImageView(image: UIImage(named: "crm logo"))
    private lazy var splitvc = UISplitViewController(style: .doubleColumn)
    
    var isUserLoggedIn: Bool {
        get {
            UserDefaultsManager.shared.isUserLoggedIn()
        }
    }
    var isFirstUse: Bool  {
        get {
            UserDefaultsManager.shared.isFirstTimeLogin()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpViewController()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureLogoView()
    }
    
    func configureLogoView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        //        logoImageView.image.rat
        
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
                let loginVC = LoginViewController()
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
            }
        }
    }
    
    private func presentSplitView() {

        let menuViewController = MenuVC()
        let homeViewController = HomeViewController()
        
        let navigationVC = UINavigationController(rootViewController: menuViewController)
        
        splitvc.modalPresentationStyle = .fullScreen
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didTapCloseButton))
        leftSwipeGesture.direction = .left
        
        menuViewController.view.addGestureRecognizer(leftSwipeGesture)
//        menuViewController.navigationController?.navigationBar.addGestureRecognizer(leftSwipeGesture)
        
        if self.traitCollection.userInterfaceIdiom == .phone {
            
            menuViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
            
            let navigationLeftButton = UIImage(systemName: "list.dash")
            homeViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: navigationLeftButton, style: .plain, target: self, action: #selector(menuButtonTapped))
        }
        
        splitvc.setViewController(navigationVC, for: .primary)
        splitvc.setViewController(homeViewController, for: .secondary)
        
        present(splitvc, animated: true)
    }
    
    @objc private func menuButtonTapped() {
        
        splitvc.show(.primary)
    }
    
    @objc private func didTapCloseButton() {
        
        splitvc.show(.secondary)
    }
    
    
}
