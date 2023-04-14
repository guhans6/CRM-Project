//
//  DashBoardView.swift
//  NewHomePage
//
//  Created by guhan-pt6208 on 13/04/23.
//

import UIKit

class DashBoardView: UIView {
    
    private let headingLabel = UILabel()
    private let belowView = DashBoardSuplementaryView()
    private let eventDashboardView = DashBoardSuplementaryView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUp() {
        
        setHeading()
        
        // Create a horizontal stack view
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 15.0
            
        // Add the belowView and eventDashboardView to the stack view
        stackView.addArrangedSubview(belowView)
        belowView.setupIconImage(UIImage(named: "Table3"))
        belowView.setSubLabel("Tables Booked")
        
        stackView.addArrangedSubview(eventDashboardView)
        eventDashboardView.setSubLabel("Halls Booked")
        eventDashboardView.setupIconImage(UIImage(named: "party"))
        
        // Add the stack view to the main view
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            // Constrain the stack view to the bottom of the headingLabel and to the edges of the parent view
            stackView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func setHeading() {
        
        addSubview(headingLabel)
        
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headingLabel.text = "Stats"
        let fontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
        headingLabel.font = fontMetrics.scaledFont(for: .systemFont(ofSize: 25, weight: .semibold))
        headingLabel.textColor = .label
        
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            headingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func setBelowView() {
        
        addSubview(belowView)
        belowView.translatesAutoresizingMaskIntoConstraints = false
        belowView.setSubLabel("Tables booked")
        
        NSLayoutConstraint.activate([
            belowView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 20),
            belowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            belowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            belowView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -15)
//            belowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    private func setEventDashboardView() {
        addSubview(eventDashboardView)
        eventDashboardView.translatesAutoresizingMaskIntoConstraints = false
        eventDashboardView.setSubLabel("Halls Booked")
        
        NSLayoutConstraint.activate([
            eventDashboardView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 20),
            eventDashboardView.leadingAnchor.constraint(equalTo: belowView.trailingAnchor, constant: 15),
            eventDashboardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            eventDashboardView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -15)
        ])
    }
    
}

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
        
        countLabel.text = "30"
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
    
    func setupCountLabel(_ mainLabelText: String) {
        
        countLabel.text = mainLabelText
    }
    
    func setSubLabel(_ text: String) {
        
        subLabel.text = text
    }
}
