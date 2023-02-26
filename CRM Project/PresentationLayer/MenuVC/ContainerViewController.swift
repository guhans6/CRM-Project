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
        addChild(menuVC)
        menuVC.delegate = self
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        // Home
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
        
        
        switch contains {
        case "Modules":
            
            let moduleTableVC = ModulesTableViewController()
            let _ = UINavigationController(rootViewController: moduleTableVC)
            homeVC.navigationController?.pushViewController(moduleTableVC, animated: true)
        default :
            
            print("No Options Selected")
        }
        toogleMenu()
    }
}
