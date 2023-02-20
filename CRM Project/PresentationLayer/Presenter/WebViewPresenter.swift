//
//  WebViewPresenter.swift
//  CRM C
//
//  Created by guhan-pt6208 on 20/02/23.
//

import Foundation

class WebViewPresenter {
    
    private let networkController = NetworkController()
    
    func getRegistrationURL() -> String {
        networkController.getRegistrationURL()
    }
    
    func generateAccessToken(from url: URL?) {
        networkController.generateAccessToken(from: url)
    }
}
