//
//  RecordCollectionViewCell.swift
//  CRM C
//
//  Created by guhan-pt6208 on 31/03/23.
//

import UIKit

class RecordCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "recordCollectionViewCell"
    
    let imageview : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "camera")
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
//        label.adjustsFontSizeToFitWidth = true
        
        let fontMetrics = UIFontMetrics(forTextStyle: .headline)
        label.font = fontMetrics.scaledFont(for: label.font)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
//        label.lineBreakMode = .byTruncatingMiddle
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        
        let fontMetrics = UIFontMetrics(forTextStyle: .title2)
        label.font = fontMetrics.scaledFont(for: label.font)
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakMode = .byTruncatingMiddle
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
//        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setConstrains()
    }
    
    override func prepareForReuse() {
        
        imageview.image = UIImage(named: "camera")
        nameLabel.text = nil
        secondaryLabel.text = nil
    }
    
    var heightSpace : CGFloat {
        contentView.frame.height * 0.04
    }
    
    var widthSpace : CGFloat {
        contentView.frame.width * 0.05
    }
    
    func setConstrains(){
        contentView.addSubview(imageview)
        contentView.addSubview(nameLabel)
        contentView.addSubview(secondaryLabel)
        
        
        
        layer.cornerRadius = 10
        //       layer.shadowColor = UIColor(named: "shadow")?.cgColor
        //       layer.shadowOpacity = 0.5
        //       layer.shadowOffset = CGSize(width: 2, height: 2)
        //       layer.shadowRadius = 5
        
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 10
        
        let imageHeight = contentView.frame.height * 0.45
        
        let height = contentView.frame.height * 0.11
        
        NSLayoutConstraint.activate([
            imageview.topAnchor.constraint(equalTo: contentView.topAnchor,constant: heightSpace),
            imageview.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageview.heightAnchor.constraint(equalToConstant: imageHeight),
            imageview.widthAnchor.constraint(equalToConstant: imageHeight)
        ])
        
        imageview.layer.cornerRadius = imageHeight / 2
        
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageview.bottomAnchor, constant: 15),
//            nameLabel.heightAnchor.constraint(equalToConstant: height),dd
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: widthSpace),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthSpace)
        ])
        
        NSLayoutConstraint.activate([
            secondaryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            secondaryLabel.heightAnchor.constraint(equalToConstant: height),
            secondaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: widthSpace),
            secondaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthSpace)
        ])
        
    }
    
}
