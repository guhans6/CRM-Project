//
//  ImageTableViewCell.swift
//  CRM C
//
//  Created by guhan-pt6208 on 31/03/23.
//

import UIKit

class ImageTableViewCell: FormTableViewCell {
    
    static let identifier = "imageCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLabel()
        configureImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func configureImageView() {
        
        contentView.addSubview(recordImageView)
        recordImageView.translatesAutoresizingMaskIntoConstraints = false
        recordImageView.isUserInteractionEnabled = true
        recordImageView.image = UIImage(named: "camera")
        recordImageView.layer.cornerRadius = 30
        recordImageView.clipsToBounds = true
        recordImageView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            recordImageView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10),
            recordImageView.heightAnchor.constraint(equalToConstant: 60),
            recordImageView.widthAnchor.constraint(equalToConstant: 60),
            recordImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    override func getFieldData(for type: String) -> (Any?, Bool) {
        
        
        return (recordImageView.image, true)
    }
    
    
    private func saveData() {
        
        
    }
}
