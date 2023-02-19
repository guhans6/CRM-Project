//
//  SplashViewContract.swift
//  CRM C
//
//  Created by guhan-pt6208 on 19/02/23.
//

import Foundation

protocol SplashViewPresenterContract: AnyObject {
    
    func naviagteToLogin() -> Void
    func navigateToCRM() -> Void
}

protocol SplashViewRouterContract: AnyObject {
    
    func showLoginView() -> Void
    func showCRMHomeView() -> Void
}
