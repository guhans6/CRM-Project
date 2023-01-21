//
//  ViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 18/01/23.
//

import UIKit
import WebKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate {
    
    private let openLinkButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    deinit {
        print("Done")
    }
    
    
    private func configureUI() {
        view.backgroundColor = .systemPink
        
        configureOpenLinkButton()
    }
    
    private func configureOpenLinkButton() {
        view.addSubview(openLinkButton)
        openLinkButton.translatesAutoresizingMaskIntoConstraints = false
        openLinkButton.setTitle("Open Website", for: .normal)
        openLinkButton.setTitleColor(.white, for: .normal)
        openLinkButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
        openLinkButton.addTarget(self, action: #selector(didTapOpenLinkButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            openLinkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openLinkButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            //            openLinkButton.widthAnchor.constraint(equalToConstant: 170)
        ])
        
    }
    
    @objc private func didTapOpenLinkButton() {
        
        let navController = UINavigationController(rootViewController: WebViewController())
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
        
    }
}

