//
//  TableCollectionViewCell.swift
//  NewHomePage
//
//  Created by guhan-pt6208 on 11/04/23.
//

import UIKit

class TableCollectionViewCell: UICollectionViewCell {

    let imageView = UIImageView()
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let tableNameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        backgroundColor = UIColor(named: "Background")
        layer.cornerRadius = 10
        clipsToBounds = true

        // Add shadow
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2)
//        layer.shadowOpacity = 0.5
//        layer.shadowRadius = 4
        
        self.contentView.layer.cornerRadius = 10.0
//        self.contentView.layer.borderWidth = 1.0
//        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius - 5).cgPath
        
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)

        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nameLabel.textColor = .label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        emailLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        emailLabel.textColor = .secondaryLabel
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailLabel)

        tableNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        tableNameLabel.text = ""
        tableNameLabel.textColor = .secondaryLabel
        tableNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableNameLabel)

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: emailLabel.topAnchor, constant: -4),
            
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            emailLabel.bottomAnchor.constraint(equalTo: tableNameLabel.topAnchor, constant: -4),
            
            tableNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            tableNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            tableNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -8),

        ])
    }
    
    func configureCellWith(_ image: UIImage?, _ nameLabelText: String, _ subLabelText: String) {
        
        if let image = image {
            imageView.image = image
        }
        nameLabel.text = nameLabelText
        tableNameLabel.text = subLabelText
    }

}


//class TableCollectionViewCell: UICollectionViewCell {
//
//    let containerView = UIView()
//    let imageView = UIImageView()
//    let nameLabel = UILabel()
//    let emailLabel = UILabel()
//    let tableNameLabel = UILabel()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupViews()
//    }
//
//    private func setupViews() {
//        backgroundColor = .clear
//        containerView.backgroundColor = .white
//        containerView.layer.cornerRadius = 8
//        containerView.clipsToBounds = true
//        containerView.layer.shadowColor = UIColor.gray.cgColor
//        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        containerView.layer.shadowOpacity = 0.4
//        containerView.layer.shadowRadius = 4
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(containerView)
//
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.backgroundColor = .lightGray
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(imageView)
//
//        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(nameLabel)
//
//        emailLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        emailLabel.textColor = .gray
//        emailLabel.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(emailLabel)
//
//        tableNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        tableNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(tableNameLabel)
//
//        NSLayoutConstraint.activate([
//            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
//            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
//            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
//            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
//
//            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
//            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -8),
//
//            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
//            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
//            nameLabel.bottomAnchor.constraint(equalTo: emailLabel.topAnchor, constant: -4),
//
//            emailLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
//            emailLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
//            emailLabel.bottomAnchor.constraint(equalTo: tableNameLabel.topAnchor, constant: -4),
//
//            tableNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
//            tableNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
//            tableNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
//        ])
//    }
//
//}
