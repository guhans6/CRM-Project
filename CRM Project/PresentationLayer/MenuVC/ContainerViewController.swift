//
//  ContainerViewController.swift
//
//  Created by guhan-pt6208 on 25/02/23.
//

import UIKit

class ContainerViewController: UIViewController {
    
    private let menuVC = MenuVC()
    private let homeVC = HomeViewController()
    
    private var navigationVC: UINavigationController?
    private var isMenuClosed = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureUI()
    }

    override func viewDidLayoutSubviews() {
        if isMenuClosed {
            isMenuClosed = false
        } else  {
            isMenuClosed = true
        }
        toogleMenu()
    }

    private func configureUI() {
        // Add Menu
        
        configureMenuView()
        
        //      Home
        configureHomeView()
        
        let swipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.edges = .left
        
        // Add the gesture recognizer to the view
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func handleSwipeGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {

        if isMenuClosed {
            toogleMenu()
        }
    }
    
    private func configureMenuView() {
        addChild(menuVC)
        menuVC.delegate = self
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        menuVC.logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipped(_:)))
        leftSwipeGesture.direction = .left
        menuVC.view.addGestureRecognizer(leftSwipeGesture)
    }
    
    @objc private func logoutButtonTapped() {
           UserDefaultsManager.shared.setLogIn(equalTo: false)
           dismiss(animated: true)
   }
    
    @objc private func leftSwipped(_ sender: UISwipeGestureRecognizer) {
        if isMenuClosed == false {
            toogleMenu()
        }
    }
    
    private func configureHomeView() {
        
        let navVC = UINavigationController(rootViewController: homeVC)
        homeVC.delegate = self
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self )
        self.navigationVC = navVC
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedInHomeView))
        homeVC.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tappedInHomeView() {
        if isMenuClosed == false {
            toogleMenu()
        }
    }
}

extension ContainerViewController: HomeViewDelegate {
    
    func didTapMenuButton() {
        
        toogleMenu()
    }
    
    func toogleMenu() {
        
        if isMenuClosed {
            
            UIView.animate(withDuration: 0.5) {
                self.navigationVC?.view.frame.origin.x = self.homeVC.view.frame.width - 100
                self.isMenuClosed = false
            }
        } else {
            
            UIView.animate(withDuration: 0.5) {
                self.navigationVC?.view.frame.origin.x = 0
                self.isMenuClosed = true
            }
        }
    }
}

extension ContainerViewController: MenuViewDelegate {
    
    func didSelectRow(contains: String) {
        
        if isMenuClosed == false {
            
            switch contains {
            case "Modules":
                
                let moduleTableVC = ModulesTableViewController()
                let _ = UINavigationController(rootViewController: moduleTableVC)
                homeVC.navigationController?.pushViewController(moduleTableVC, animated: true)
                
            case "Table Booking":
                let tableBookingVC = TableBookingViewController()
                homeVC.navigationController?.pushViewController(tableBookingVC, animated: true)
            default :
                
                print("No Options Selected")
            }
            toogleMenu()
        }
    }
}
