//
//  DashBoardSupplementaryView.swift
//  CRM C
//
//  Created by guhan-pt6208 on 14/04/23.
//

import UIKit

class DashBoardSuplementaryView: UIView {
    
    private let iconView = UIImageView()
    private let countLabel = UILabel()
    private let subLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        
        backgroundColor = UIColor(named: "Background")
        layer.cornerRadius = 10
        
        setupIconView()
        configureMainLabel()
        configureSubLabel()
    }
    
    private func setupIconView() {
        
        addSubview(iconView)
        iconView.image = UIImage(systemName: "square.and.arrow.up")
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            iconView.heightAnchor.constraint(equalToConstant: 30),
            iconView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureMainLabel() {
        
        countLabel.textColor = .label
        countLabel.font = .preferredFont(forTextStyle: .headline)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            
        ])
    }
    
    private func configureSubLabel() {
        
        addSubview(subLabel)
        
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subLabel.text = "tables booked"
        subLabel.textColor = .secondaryLabel
        subLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        subLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            subLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 23),
            subLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
//            subLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setupIconImage(_ image: UIImage?) {
        
        iconView.image = image
    }
    
    func setupCountLabel(_ countLabelText: String) {
        
        countLabel.text = countLabelText
    }
    
    func setSubLabel(_ text: String) {
        
        subLabel.text = text
    }
}
