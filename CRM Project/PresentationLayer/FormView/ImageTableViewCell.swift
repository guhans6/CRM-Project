//
//  ImageTableViewCell.swift
//  CRM C
//
//  Created by guhan-pt6208 on 31/03/23.
//

import UIKit

class ImageTableViewCell: FormTableViewCell {
    
    static let identifier = "imageCell"
    let hiddenButton = UIButton()
    private lazy var defaultImage = UIImage(named: "camera")
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLabel()
        configureImageView()
        configureButton()
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
        recordImageView.image = defaultImage
        recordImageView.layer.cornerRadius = 30
        recordImageView.clipsToBounds = true
        recordImageView.backgroundColor = .systemBackground
        recordImageView.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([
            recordImageView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10),
            recordImageView.heightAnchor.constraint(equalToConstant: 60),
            recordImageView.widthAnchor.constraint(equalToConstant: 60),
            recordImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func configureButton() {
        
        recordImageView.addSubview(hiddenButton)
        
        // Auto layout config to pin button to the edges of the content view
        hiddenButton.translatesAutoresizingMaskIntoConstraints = false
        hiddenButton.leadingAnchor.constraint(equalTo: recordImageView.leadingAnchor).isActive = true
        hiddenButton.topAnchor.constraint(equalTo: recordImageView.topAnchor).isActive = true
        hiddenButton.trailingAnchor.constraint(equalTo: recordImageView.trailingAnchor).isActive = true
        hiddenButton.bottomAnchor.constraint(equalTo: recordImageView.bottomAnchor).isActive = true
        
    }

    override func getFieldData(for type: String) -> (Any?, Bool) {
        
        
        return (recordImageView.image, true)
    }
    
    
    private func saveData() {
        
        
    }
    
    func removeImage() {
        recordImageView.image = defaultImage
    }
    
    func isDefualtImage() -> Bool {
        
        recordImageView.image == defaultImage ? true : false
    }
}
