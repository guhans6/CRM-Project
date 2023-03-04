//
//  TableViewExtension.swift
//  CRM C
//
//  Created by guhan-pt6208 on 24/02/23.
//

import UIKit

extension UITableView {
    
    func showLoadingIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        self.backgroundView = activityIndicator
        self.separatorStyle = .none
    }
    
    func hideLoadingIndicator() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
    
    /// This is used when there is no data in a table view with a custom message
    func setEmptyView(title: String, message: String) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = .normalText
//        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        titleLabel.font = .preferredFont(forTextStyle: .title3)
        
        messageLabel.textColor = UIColor.lightGray
//        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        messageLabel.font = .preferredFont(forTextStyle: .body)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        
        backgroundView = nil
        separatorStyle = .singleLine
    }
}
