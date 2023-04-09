//
//  SplashViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 26/01/23.
//

import UIKit

class SplashViewController: UIViewController {
    
    private lazy var logoImageView = UIImageView(image: UIImage(named: "OnlyText"))
    private lazy var appLabel = UILabel()
    private let splitvc = UISplitViewController(style: .doubleColumn)
    private let mainTabBarController = UITabBarController()
    
    private let menuViewController = MenuViewController()
    private let homeViewController = HomeViewController()
    private let tableBookingViewController = TableBookingViewController()
    private let loginViewController = LoginViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    private var isMenuOpen = false
    
    var isUserLoggedIn: Bool {
        get {
            UserDefaultsManager.shared.isUserLoggedIn()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
//        configureSplitView()
        configureTabBarController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainTabBarController.selectedIndex = 0
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
//        view.addSubview(logoImageView)
//
//        logoImageView.translatesAutoresizingMaskIntoConstraints = false
//        logoImageView.contentMode = .scaleAspectFit
//
//        NSLayoutConstraint.activate([
//            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            logoImageView.heightAnchor.constraint(equalToConstant: 60)
//        ])
        
        view.addSubview(appLabel)
        appLabel.text = "Hotel Hub"
        appLabel.textAlignment = .center
        
        let fontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
        appLabel.font = fontMetrics.scaledFont(for: .systemFont(ofSize: 40, weight: .semibold))
        
        appLabel.textColor = UIColor(named: "primary")
        appLabel.translatesAutoresizingMaskIntoConstraints = false
        appLabel.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            appLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            appLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appLabel.heightAnchor.constraint(equalToConstant: 60),
            appLabel.widthAnchor.constraint(equalToConstant: view.frame.width)
            
        ])
    }
    
    func setUpViewController() {
        
        if UserDefaultsManager.shared.isUserLoggedIn() {

            present(mainTabBarController, animated: true)
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

                self.loginViewController.modalPresentationStyle = .fullScreen
                self.present(self.loginViewController, animated: true)
            }
        }
    }
    
    private func configureTabBarController() {
        
        let menuVC = UINavigationController(rootViewController: menuViewController)
        let tableBookingVC = UINavigationController(rootViewController: tableBookingViewController)
        let homeNavigationVC = UINavigationController(rootViewController: homeViewController)
        
        mainTabBarController.tabBar.autoresizesSubviews = false
        mainTabBarController.setViewControllers([homeNavigationVC, tableBookingVC, menuVC], animated: false)
        mainTabBarController.selectedIndex = 0
        mainTabBarController.tabBar.backgroundColor = .systemBackground
        mainTabBarController.tabBar.items?[0].image = UIImage(systemName: "house")
        mainTabBarController.tabBar.items?[0].title = "Home"
        mainTabBarController.tabBar.items?[1].image = UIImage(systemName: "fork.knife.circle")
        mainTabBarController.tabBar.items?[1].title = "Book Table"
        mainTabBarController.tabBar.items?[2].image = UIImage(systemName: "list.dash")
        mainTabBarController.tabBar.items?[2].title = "Menu"

        mainTabBarController.modalPresentationStyle = .fullScreen
    }
}

extension SplashViewController: MenuViewDelegate {
    
    func didSelectRow(row: Int, title: String) {
        
        isMenuOpen = true
        
        switch title {
    
        case "Modules".localized():
            
            let moduleTableVC = ModulesTableViewController()
            
            moduleTableVC.modalPresentationStyle = .fullScreen
            menuViewController.navigationController?.pushViewController(moduleTableVC, animated: true)
//            mainTabBarController.navigationController?.pushViewController(moduleTableVC, animated: true)
//            didTapCloseButton()
            
        case "Generate Auth Token".localized():
            
            NetworkController().generateAuthToken()
        default :
            
            print("No Options Selected")
        }
    }
}
