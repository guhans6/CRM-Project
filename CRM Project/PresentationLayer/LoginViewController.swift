//
//  ViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 18/01/23.
//

import UIKit
class LoginViewController: UIPageViewController {
    
    private var pages = [UIViewController]()
    private let pageControl = UIPageControl()
    private let loginButton = UIButton()
    private let initialPage = 0
    private var isLoggedIn: Bool = false
    private var hotelHubLabel = UILabel()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return .portrait
    }
    
    deinit {
        print("Main View Controller Deinitialized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaultsManager.shared.isUserLoggedIn() {
            dismiss(animated: true)
        }
    }
    
    private func configureUI() {
        
//        configureImageView()
        view.backgroundColor = .systemGray6
        configurePages()
        style()
        layout()
        configureLoginButton()
    }
    
    private func configurePages() {
        
        dataSource = self
        delegate = self
        
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)

        // create an array of viewController
        let page1 = LoginPageViewController()
        let bar = UIImage(named: "hotel")
        page1.setUpPageWith(image: bar,
                            title: "Manage your hotel with ease",
                            body: nil, shouldAnimate: true)
        
        let page2 = LoginPageViewController()
        page2.setUpPageWith(image: UIImage(named: "restaurantTable"),
                            title: "Effortlessly book and manage tables",
                            body: nil)
        
        let page3 = LoginPageViewController()
        page3.setUpPageWith(image: UIImage(named: "people"),
                            title: "Plan and host events like a pro",
                            body: nil)

        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        // set initial viewController to be displayed
        // Note: We are not passing in all the viewControllers here. Only the one to be displayed.
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    private func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
    }
    
    private func layout() {
        view.addSubview(pageControl)
        //        pageControl.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            //            view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 1),
        ])
    }
    
    private func configureImageView() {
        
        view.addSubview(hotelHubLabel)
        hotelHubLabel.translatesAutoresizingMaskIntoConstraints = false
        hotelHubLabel.text = "Hotel Hub"
        hotelHubLabel.textColor = .white
        hotelHubLabel.font = .systemFont(ofSize: 30, weight: .bold)
        
        NSLayoutConstraint.activate([
            
            hotelHubLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (view.frame.height / 2) / 2),
            hotelHubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureLoginButton() {
        
        view.addSubview(loginButton)
        view.bringSubviewToFront(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelColour = #colorLiteral(red: 0.2901960784, green: 0.4588235294, blue: 0.6745098039, alpha: 1)
        
        loginButton.backgroundColor = titleLabelColour
        loginButton.setTitle("Login".localized(), for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .medium)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 23
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
//            loginButton.topAnchor.constraint(greaterThanOrEqualTo: view.centerYAnchor, constant: 100),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            loginButton.centerYAnchor.constraint(greaterThanOrEqualTo: view.centerYAnchor, constant: 300),
            loginButton.widthAnchor.constraint(equalToConstant: 150),
            loginButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    @objc private func didTapLoginButton() {
        
        if NetworkMonitor.shared.isConnected {
            
            let navController = UINavigationController(rootViewController: WebViewController())
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        } else {
            
            let alertController = UIAlertController(title: "Network Connection Required", message: "Please connect to a network to continue", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default)

            alertController.addAction(okAction)

            self.present(alertController, animated: true, completion:nil)

        }
    }
}

extension LoginViewController {
    
    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
    }
}

extension LoginViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return pages.last               // wrap to last
        } else {
            return pages[currentIndex - 1]  // go previous
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]  // go next
        } else {
            return pages.first              // wrap to first
        }
    }
}

// MARK: - Delegates

extension LoginViewController: UIPageViewControllerDelegate {
    
    // How we keep our pageControl in sync with viewControllers
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
    }
}
