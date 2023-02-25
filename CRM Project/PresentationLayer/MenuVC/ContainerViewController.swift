//
//  ContainerViewController.swift
//
//  Created by guhan-pt6208 on 25/02/23.
//

import UIKit

class ContainerViewController: UIViewController {
    
    private let menuVC = MenuVC()
    private let homeVC = HomeVC()
    
    private var navigationVC: UINavigationController?
    private var isMenuClosed = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureUI()
    }


    private func configureUI() {
        // Add Menu
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        // Home
        let navVC = UINavigationController(rootViewController: homeVC)
        homeVC.delegate = self
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self )
        self.navigationVC = navVC
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

