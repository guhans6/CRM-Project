//
//  TextAreaTableViewCell.swift
//  CRM C
//
//  Created by guhan-pt6208 on 22/02/23.
//

import UIKit

class TextAreaTableViewCell: FormTableViewCell {

    static let textAreaCellIdentifier = "textAreaCell"
    private let textView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textView.text = nil
    }
    
    func configureTextView() {
        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemBackground
        textView.font = .systemFont(ofSize: 15)
        textView.autocorrectionType = .no
        textView.delegate = self
        
        NSLayoutConstraint.activate([
//            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
            textView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func setRecordData(for data: Any, isEditable: Bool = true) {
        self.textView.text = data as? String
        self.isUserInteractionEnabled = isEditable
    }
    
    override func getFieldData(for type: String) -> (Any?, Bool) {
        
        
        return (textView.text, true)
    }
    
}

extension TextAreaTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        delegate?.textFieldData(data: textView.text, isValid: true, index: index)
    }
}
