//
//  SplashViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 26/01/23.
//

import UIKit

class SplashViewController: UIViewController {
    
    let logoImageView = UIImageView(image: UIImage(named: "crm logo"))
    var splashViewPresenter: SplashViewPresenterContract?
    var isUserLoggedIn: Bool {
        get {
            UserDefaultsManager.shared.isUserLoggedIn()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpViewController()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureLogoView()
    }
    
    func configureLogoView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        //        logoImageView.image.rat
        
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setUpViewController() {
        
        if UserDefaultsManager.shared.isUserLoggedIn() {
            let loginVC = HomeViewController()
            let navController = UINavigationController(rootViewController: loginVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
            
//            splashViewPresenter?.navigateToCRM()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let loginVC = LoginViewController()
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
//                self.splashViewPresenter?.naviagteToLogin()
            }
        }
    }
    
}

//let size = topLabel.sizeThatFits(CGSize(width: view.bounds.size.width, height: CGFLOAT_MAX))
