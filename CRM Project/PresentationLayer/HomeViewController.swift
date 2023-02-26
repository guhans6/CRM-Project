//
//  LoggedInViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 25/01/23.
//

import UIKit

protocol HomeViewDelegate: AnyObject {
    
    func didTapMenuButton() -> Void
}

class HomeViewController: UIViewController {
    
    var presenter: HomeViewPresenterContract? = HomeViewPresenter()
    weak var delegate: HomeViewDelegate?
    
    let welcomeUserLabel = UILabel()
    let requestButton = UIButton()
    let generateAuthTokenButton = UIButton()
    let darkModeSwitch = UISwitch()
    lazy var textColour = UIColor(named: "TextColour")
    
    deinit {
        print("Login deinitialized")
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Home"
        
//        navigationController?.navigationBar.backgroundColor = UIColor(named: "TableSelect")

        presenter?.generateAuthToken()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        presenter?.generateAuthToken()
    }
    
    private func configureUI() {
        
        configureRequestButton()
        configureGenerateAuthTokenButton()
        configureWelcomeUserlabel()
        
        let navigationLeftButton = UIImage(systemName: "list.dash")
//        let navigationLeftButton = UIImage(systemName: "line.3.horizontal")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: navigationLeftButton, style: .plain, target: self, action: #selector(menuButtonTapped))
    }
    
    @objc private func menuButtonTapped() {
        delegate?.didTapMenuButton()
    }
    
    private func configureWelcomeUserlabel() {
        view.addSubview(welcomeUserLabel)
        welcomeUserLabel.translatesAutoresizingMaskIntoConstraints = false
        
        welcomeUserLabel.text = "Welcome "
        welcomeUserLabel.textAlignment = .center
        welcomeUserLabel.font = .systemFont(ofSize: 20, weight: .medium)
        
        NSLayoutConstraint.activate([
            welcomeUserLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeUserLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            
        ])
    }
    
    @objc private func logoutButtonTapped() {
        UserDefaultsManager.shared.setLogIn(equalTo: false)
        dismiss(animated: true)
    }
    
    private func configureRequestButton() {
        view.addSubview(requestButton)
        requestButton.translatesAutoresizingMaskIntoConstraints = false

        
        requestButton.setTitle("Make Request", for: .normal)
        requestButton.setTitleColor(.label, for: .normal)
        requestButton.addTarget(self, action: #selector(makeRequestButtonTapped), for: .touchUpInside)
        requestButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        NSLayoutConstraint.activate([
            requestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            requestButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            
        ])
    }
    
    @objc private func makeRequestButtonTapped() {
        
        self.navigationController?.pushViewController(TableBookingViewController(), animated: true)
    }

    private func configureGenerateAuthTokenButton() {
        view.addSubview(generateAuthTokenButton)
        generateAuthTokenButton.translatesAutoresizingMaskIntoConstraints = false

        generateAuthTokenButton.setTitle("Generate new Token", for: .normal)
        generateAuthTokenButton.setTitleColor(.label, for: .normal)
        generateAuthTokenButton.addTarget(self, action: #selector(generateTokenButtonTapped), for: .touchUpInside)
        generateAuthTokenButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        NSLayoutConstraint.activate([
            generateAuthTokenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            generateAuthTokenButton.centerYAnchor.constraint(equalTo: requestButton.bottomAnchor, constant: 50),
            
        ])
    }
    
    @objc private func generateTokenButtonTapped() {
        presenter?.generateAuthToken()
    }
    
//    private func configureDarkModeSwitch() {
//
//        view.addSubview(darkModeSwitch)
//        darkModeSwitch.translatesAutoresizingMaskIntoConstraints = false
//
//        darkModeSwitch.addTarget(self, action: #selector(darkModeButtonTapped), for: .touchUpInside)
//
//        NSLayoutConstraint.activate([
//            darkModeSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            darkModeSwitch.centerYAnchor.constraint(equalTo: modulesViewButton.bottomAnchor, constant: 40),
//
//        ])
//    }
    
//    @objc private func darkModeButtonTapped() {
//
//        let appDelegate = UIApplication.shared.windows.first
//
//        if #available(iOS 13.0, *) {
//            if darkModeSwitch.isOn {
//                appDelegate?.overrideUserInterfaceStyle = .dark
//                return
//            }
//            appDelegate?.overrideUserInterfaceStyle = .light
//        }
//    }
}
