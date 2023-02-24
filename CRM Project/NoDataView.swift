//
//  NoDataView.swift
//  CRM C
//
//  Created by guhan-pt6208 on 24/02/23.
//

import UIKit

class NoDataView: UIView {
    
    private let messageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubviews()
    }
    
    private func configureSubviews() {
        messageLabel.text = "No data available"
        messageLabel.textAlignment = .center
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setMessage(_ message: String) {
        messageLabel.text = message
    }
}
