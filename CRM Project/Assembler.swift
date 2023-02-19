//
//  Assembler.swift
//  CRM C
//
//  Created by guhan-pt6208 on 17/02/23.
//

import UIKit


class Assembler {
    
    static func getSplashView(router: Router) -> SplashViewController {
        
        let splashView = SplashViewController()
        let splashViewPresenter = SplashViewPresenter()
        
        splashView.splashViewPresenter = splashViewPresenter
        router.viewController = splashView
        splashViewPresenter.router = router
        splashView.modalPresentationStyle = .fullScreen
        return splashView
    }
    
    static func getLoginViewController(router: Router) -> LoginViewController {
        let loginVC = LoginViewController()
        router.viewController = loginVC
        return loginVC
    }
    
    static func getHomeViewController(router: Router) -> HomeViewController {
        
        let homeVC = HomeViewController()
        let _ = UINavigationController(rootViewController: homeVC)
        let homeViewPresenter = HomeViewPresenter()
        homeViewPresenter.router = router
//        homeViewPresenter.homeView = homeVC
//        homeViewPresenter.
        
        homeVC.presenter = homeViewPresenter
        homeVC.modalPresentationStyle = .fullScreen
        return homeVC
    }
    
    
    static func getModuleTableView(router: Router) -> ModulesTableViewController {
        
        let networkController = NetworkController()
        let modulesPresenter = ModulesPresenter()
        let modulesViewController = ModulesTableViewController()
        
        modulesViewController.modulePresenter = modulesPresenter
        modulesPresenter.router = router
        modulesPresenter.networkController = networkController
        modulesPresenter.moduleTableView = modulesViewController
        return modulesViewController
    }
    
    static func getRecordsView(router: Router) {
        
    }
}
