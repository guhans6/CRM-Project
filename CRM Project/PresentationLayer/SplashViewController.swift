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
    private var mainTabBarController = UITabBarController()
    
    private var menuViewController = MenuViewController()
    private var homeViewController = HomeViewController2()
    private var tableBookingViewController = TableBookingViewController()
    private var loginViewController = LoginViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var moduleViewController = ModulesTableViewController()
    
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
        
        mainTabBarController = UITabBarController()
        configureTabBarController()
        mainTabBarController.selectedIndex = 0
        menuViewController = MenuViewController()
        homeViewController = HomeViewController2()
        tableBookingViewController = TableBookingViewController()
        loginViewController = LoginViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        moduleViewController = ModulesTableViewController()
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
            
            Database.shared.openDatabase()
            DatabaseService.shared.createAllTables()
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
        let moduleVC = UINavigationController(rootViewController: moduleViewController)
        
        mainTabBarController.tabBar.autoresizesSubviews = false
        mainTabBarController.setViewControllers([homeNavigationVC, tableBookingVC, moduleVC, menuVC], animated: false)
        mainTabBarController.selectedIndex = 0
        mainTabBarController.tabBar.backgroundColor = .systemBackground
        mainTabBarController.tabBar.items?[0].image = UIImage(systemName: "house")
        mainTabBarController.tabBar.items?[0].title = "Home"
        mainTabBarController.tabBar.items?[1].image = UIImage(systemName: "fork.knife.circle")
        mainTabBarController.tabBar.items?[1].title = "Reserve Table"
        mainTabBarController.tabBar.items?[2].image = UIImage(systemName: "list.bullet")
        mainTabBarController.tabBar.items?[2].title = "Modules"
        mainTabBarController.tabBar.items?[3].image = UIImage(systemName: "gearshape")
        mainTabBarController.tabBar.items?[3].title = "Settings"
        

        mainTabBarController.modalPresentationStyle = .fullScreen
    }
}

extension SplashViewController: MenuViewDelegate {
    
    func clearData() {
        homeViewController.clearTitle()
    }
    
    func didSelectRow(row: Int, title: String) {
        
        isMenuOpen = true
        
        switch title {
    
        case "Generate Auth Token".localized():
            
            NetworkController().generateAuthToken()
        default :
            
            print("No Options Selected")
        }
    }
}
