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
    
    
    
    
    
    deinit {
        print("Login deinitialized")
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Home"
        
        navigationController?.navigationBar.backgroundColor = UIColor(named: "TableSelect")

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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(menuButtonTapped))
    }
    
    @objc private func menuButtonTapped() {
        delegate?.didTapMenuButton()
    }
    
    private func configureWelcomeUserlabel() {
        view.addSubview(welcomeUserLabel)
        welcomeUserLabel.translatesAutoresizingMaskIntoConstraints = false
        
        welcomeUserLabel.text = "Welcome "
        welcomeUserLabel.textAlignment = .center
        welcomeUserLabel.textColor = .white
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
        requestButton.setTitleColor(.white, for: .normal)
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
        generateAuthTokenButton.setTitleColor(.white, for: .normal)
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

class CustomNavigationBar: UINavigationBar {
    
    private let navigationBarHeight: CGFloat = 70.0
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let newSize = CGSize(width: UIScreen.main.bounds.width, height: navigationBarHeight)
        return newSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let y = (frame.height - navigationBarHeight) / 2.0
        let titleViewWidth: CGFloat = 200.0
        let titleViewHeight: CGFloat = 40.0
        let titleViewX = (frame.width - titleViewWidth) / 2.0
        let titleViewY = y + (navigationBarHeight - titleViewHeight) / 2.0
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: titleViewWidth, height: titleViewHeight))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.text = "My App Title"
        
        let titleView = UIView(frame: CGRect(x: titleViewX, y: titleViewY, width: titleViewWidth, height: titleViewHeight))
        titleView.addSubview(titleLabel)
        
        for subview in self.subviews {
            if NSStringFromClass(subview.classForCoder).contains("BarBackground") {
                subview.removeFromSuperview()
            }
        }
        
        self.addSubview(titleView)
    }
    
}
