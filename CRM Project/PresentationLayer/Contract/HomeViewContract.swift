//
//  HomeViewContract.swift
//  CRM C
//
//  Created by guhan-pt6208 on 19/02/23.
//

import Foundation

protocol HomeViewPresenterContract: AnyObject {
    
    func navigateToModule() -> Void
    func generateAuthToken() -> Void
}

protocol HomeViewRouterContract: AnyObject {
    
    func showModules() -> Void
}
