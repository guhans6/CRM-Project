//
//  RecordInfoHeaderView.swift
//  CRM C
//
//  Created by guhan-pt6208 on 02/04/23.
//

import UIKit

class RoundedImageViewHeader: UIView {
    
    private let imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "camera")
        imageView.backgroundColor = .systemGray5
        
        let imageViewHeight = 125.0
        imageView.layer.cornerRadius = imageViewHeight / 2
        
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageViewHeight), // adjust the width as desired
            imageView.heightAnchor.constraint(equalToConstant: imageViewHeight) // adjust the height as desired
        ])

    }
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
    
}
