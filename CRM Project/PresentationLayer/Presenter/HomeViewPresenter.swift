//
//  HomeViewPresenter.swift
//  CRM C
//
//  Created by guhan-pt6208 on 19/02/23.
//

import Foundation

class HomeViewPresenter: HomeViewPresenterContract {
    
    
    weak var router: HomeViewRouterContract?
    weak var homeView: HomeViewController?
    
    func navigateToModule() {
        print("this")
        router?.showModules()
    }
    
    func generateAuthToken() {
        NetworkController().generateAuthToken()
    }
}
