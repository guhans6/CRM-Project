//
//  SortView.swift
//  CRM C
//
//  Created by guhan-pt6208 on 11/04/23.
//

import UIKit

class SegmentedStackView: UIStackView {
    
    let allButton = UIButton()
    let breakfastButton = UIButton()
    let lunchButton = UIButton()
    let dinnerButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        axis = .horizontal
        distribution = .fillEqually
        alignment = .fill
        spacing = 3
        
        allButton.setTitle("All", for: .normal)
        allButton.setTitleColor(.black, for: .normal)
        breakfastButton.setTitle("Breakfast", for: .normal)
        breakfastButton.setTitleColor(.black, for: .normal)
        lunchButton.setTitle("Lunch", for: .normal)
        lunchButton.setTitleColor(.black, for: .normal)
        dinnerButton.setTitle("Dinner", for: .normal)
        dinnerButton.setTitleColor(.black, for: .normal)
        
        addArrangedSubview(allButton)
        addArrangedSubview(breakfastButton)
        addArrangedSubview(lunchButton)
        addArrangedSubview(dinnerButton)
        
//        addBackgrounds()
    }
    
    private func addBackgrounds() {
        let buttons = [allButton, breakfastButton, lunchButton, dinnerButton]
        buttons.forEach { button in
            let backgroundView = UIView()
            backgroundView.backgroundColor = .white
            backgroundView.layer.cornerRadius = 5
            backgroundView.layer.masksToBounds = true
            button.addSubview(backgroundView)
            button.sendSubviewToBack(backgroundView)
            
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                backgroundView.topAnchor.constraint(equalTo: button.topAnchor),
                backgroundView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
            ])
        }
    }

}
