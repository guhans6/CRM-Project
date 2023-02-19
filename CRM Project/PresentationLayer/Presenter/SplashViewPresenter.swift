//
//  SplashViewController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 19/02/23.
//

import Foundation

class SplashViewPresenter: SplashViewPresenterContract {
    
    weak var router: SplashViewRouterContract?
    
    func naviagteToLogin() {
        router?.showLoginView()
    }
    
    func navigateToCRM() {
        router?.showCRMHomeView()
    }
    
}
