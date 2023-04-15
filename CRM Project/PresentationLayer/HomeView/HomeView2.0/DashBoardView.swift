//
//  DashBoardView.swift
//  NewHomePage
//
//  Created by guhan-pt6208 on 13/04/23.
//

import UIKit

class DashBoardView: UIView {
    
    private let headingLabel = UILabel()
    var dropdownButton = UIButton()
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
        setFilterView()
        
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
        
        headingLabel.text = "Summary"
        let fontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
        headingLabel.font = fontMetrics.scaledFont(for: .systemFont(ofSize: 25, weight: .semibold))
        headingLabel.textColor = .label
        
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            headingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func setFilterView() {
        
        var configuration = UIButton.Configuration.borderless()
        configuration.image = UIImage(systemName: "chevron.down")
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        configuration.titlePadding = 10
        configuration.imagePadding = 10
        configuration.attributedTitle = AttributedString("Weekly", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .light), NSAttributedString.Key.foregroundColor: UIColor.label]))

        dropdownButton = UIButton(configuration: configuration)
                                                              
        dropdownButton.translatesAutoresizingMaskIntoConstraints = false
        dropdownButton.setTitleColor(.label, for: .normal)
        dropdownButton.tintColor = .background
        dropdownButton.semanticContentAttribute = .forceRightToLeft
        dropdownButton.backgroundColor = UIColor(named: "segment")
        dropdownButton.layer.cornerRadius = 10

        addSubview(dropdownButton)
        
        // Set up the dropdown button constraints
        NSLayoutConstraint.activate([
            dropdownButton.topAnchor.constraint(equalTo: headingLabel.topAnchor),
//            dropdownButton.bottomAnchor.constraint(equalTo: headingLabel.bottomAnchor),
            dropdownButton.centerYAnchor.constraint(equalTo: headingLabel.centerYAnchor),
            dropdownButton.trailingAnchor.constraint(equalTo: headingLabel.trailingAnchor, constant: -8),
            dropdownButton.widthAnchor.constraint(equalToConstant: 120)
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
    
    func setStats(stats: (String, String)) {
        
        belowView.setupCountLabel(stats.0)
        eventDashboardView.setupCountLabel(stats.1)
    }
    
}
