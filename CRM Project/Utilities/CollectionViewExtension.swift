//
//  CollectionViewExtension.swift
//  CRM C
//
//  Created by guhan-pt6208 on 31/03/23.
//

import UIKit

extension UICollectionView {

    func showLoadingIndicator() {
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        
        activityIndicator.startAnimating()
        self.backgroundView = activityIndicator
    }

    func hideLoadingIndicator() {
        restore()
    }

    /// This is used when there is no data in a collection view with a custom message
    func setEmptyView(title: String,
                      message: String,
                      image: UIImage? = nil,
                      shouldImageAnimate: Bool = false) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "wifi.slash")
        let titleLabel = UILabel()
        titleLabel.text = "No network."
        let messageLabel = UILabel()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = .normalText
        titleLabel.font = .preferredFont(forTextStyle: .title3)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        imageView.image = image
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = .preferredFont(forTextStyle: .body)
        
        emptyView.addSubview(imageView)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -50),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: emptyView.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: emptyView.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: emptyView.safeAreaLayoutGuide.leadingAnchor),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: emptyView.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        self.backgroundView = emptyView
        
        if shouldImageAnimate {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if shouldImageAnimate {
                    let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                    animation.duration = 0.2
                    animation.repeatCount = 3.0
                    animation.autoreverses = true
                    animation.fromValue = -0.15
                    animation.toValue = 0.15
                    imageView.layer.add(animation, forKey: "tilt")
                }
            }
        }
    }
    
    func showNoNetworkView() {
        
        setEmptyView(title: "Not connected to network.", message: "", image: UIImage(systemName: "wifi.slash"))
    }

    /// Call this to restore the background view
    func restore() {
        backgroundView = nil
    }
}
