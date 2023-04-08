//
//  LoginPageViewController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 30/03/23.
//

import UIKit

class LoginPageViewController: UIViewController {
    
    lazy var imageView: UIImageView = UIImageView()
    
    lazy var titleLabel: UILabel = UILabel()
    
    lazy var bodyLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        configureUI()
        viewWillAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !UserDefaultsManager.shared.isUserLoggedIn() {
            imageView.transform = CGAffineTransform(scaleX: 0.03, y: 0.03)
            imageView.alpha = 0.0
            
            // Animate the imageView with a spring effect
            UIView.animate(withDuration: 1.0,
                           delay: 0.0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.2,
                           options: .curveEaseInOut,
                           animations: {
                
                self.imageView.transform = .identity
                self.imageView.alpha = 1.0
            })
            
            titleLabel.alpha = 0.0
            titleLabel.transform = CGAffineTransform(translationX: 0, y: 20)
            bodyLabel.alpha = 0.0
            bodyLabel.transform = CGAffineTransform(translationX: 0, y: 20)
            
            // Animate the titleLabel and bodyLabel with a fade-in and slide-up effect
            UIView.animate(withDuration: 1.0,
                           delay: 0.0,
                           options: [.curveEaseInOut, .beginFromCurrentState],
                           animations: {
                self.titleLabel.alpha = 1.0
                self.titleLabel.transform = .identity
            }, completion: { _ in
                UIView.animate(withDuration: 1.0,
                               delay: 0.0,
                               options: [.curveEaseInOut, .beginFromCurrentState],
                               animations: {
                    self.bodyLabel.alpha = 1.0
                    self.bodyLabel.transform = .identity
                }, completion: nil)
            })
        }
    }
    
    private func configureUI() {
        
        confiureImageView()
        configureTitleLabel()
        configureBodyLabel()
    }
    
    private func confiureImageView() {
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = #colorLiteral(red: 0.2901960784, green: 0.4588235294, blue: 0.6745098039, alpha: 1)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func configureTitleLabel() {
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .normalText
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
        ])
    }
    
    private func configureBodyLabel() {
        
        view.addSubview(bodyLabel)
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        bodyLabel.textColor = .normalText
        bodyLabel.textAlignment = .center
        bodyLabel.numberOfLines = 0
//        label.text = "Please sign in to continue"
        
        NSLayoutConstraint.activate([
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            bodyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            bodyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        ])

    }
    
    func setUpPageWith(image: UIImage?, title: String, body: String?, shouldAnimate: Bool = false) {
        
        imageView.image = image
        titleLabel.text = title
        bodyLabel.text = body
    }
    
}
