//
//  SortView.swift
//  CRM C
//
//  Created by guhan-pt6208 on 11/04/23.
//

import UIKit

class SegmentedStackView: UIStackView {
    
    let allLabel = UILabel()
    let breakfastLabel = UILabel()
    let lunchLabel = UILabel()
    let dinnerLabel = UILabel()
    var labels: [UILabel] {
        return [allLabel, breakfastLabel, lunchLabel, dinnerLabel]
    }
    var selectedLabel: UILabel?
    let selectionView = UIView()
    var isFirst = true
    
    var lastFrame: CGRect?
    
    var data: [String]? {
        didSet {
            // Update the labels with the new data
            guard let data = data else { return }
            allLabel.text = "All (\(data.count))"
            breakfastLabel.text = "Breakfast (\(data.filter({ $0 == "Breakfast" }).count))"
            lunchLabel.text = "Lunch (\(data.filter({ $0 == "Lunch" }).count))"
            dinnerLabel.text = "Dinner (\(data.filter({ $0 == "Dinner" }).count))"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
//        setup()
    }
    
    override func didMoveToSuperview() {
        setup()
    }
    
    private func setup() {
        axis = .horizontal
        distribution = .fillEqually
        alignment = .fill
        spacing = 3
        
        allLabel.text = "All"
        breakfastLabel.text = "Breakfast"
        lunchLabel.text = "Lunch"
        dinnerLabel.text = "Dinner"
        
        selectionView.backgroundColor = .systemPink
        selectionView.layer.cornerRadius = 12
        selectionView.layer.masksToBounds = true
        addSubview(selectionView)
        bringSubviewToFront(selectionView)
        selectionView.frame = frame
        
        
        for label in labels {
            label.isUserInteractionEnabled = true
            label.textAlignment = .center
            label.textColor = .label
            label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
            label.addGestureRecognizer(tapGesture)
        }
        addArrangedSubview(allLabel)
        addArrangedSubview(breakfastLabel)
        addArrangedSubview(lunchLabel)
        addArrangedSubview(dinnerLabel)
        
        selectedLabel = allLabel
        
        allLabel.textColor = .systemBackground
        allLabel.backgroundColor = .systemYellow
        allLabel.layer.cornerRadius = 12
        allLabel.layer.masksToBounds = true
        
    }
    
    @objc private func labelTapped(_ sender: UITapGestureRecognizer?) {
        
        selectionView.isHidden = false
        guard let selectedLabel = sender?.view as? UILabel else { return }
        self.selectedLabel = selectedLabel
        
        // Deselect all labels except for the selected label
        for label in [allLabel, breakfastLabel, lunchLabel, dinnerLabel] {
            label.textColor = .label
            label.backgroundColor = .clear
        }
        
        bringSubviewToFront(selectedLabel)
        
        UIView.animate(withDuration: 0.3) {
            self.selectionView.frame = self.selectedLabel!.frame
            self.lastFrame = self.selectedLabel!.frame
//            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.1) {
//                self.selectedLabel!.textColor = .systemBackground
//            }
        }
    }

    func setUp() {
        
        labelTapped(allLabel.gestureRecognizers?.first as? UITapGestureRecognizer)
    }
    
    func resetSelectedView() {
        
        DispatchQueue.main.async { 
            if let selectedLabel = self.selectedLabel {
                self.selectionView.frame = selectedLabel.frame
            }
        }
    }
}
