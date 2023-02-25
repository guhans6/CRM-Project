//
//  HomeVC.swift
//
//  Created by guhan-pt6208 on 25/02/23.
//

import UIKit

protocol HomeViewDelegate: AnyObject {
    
    func didTapMenuButton() -> Void
}

class HomeVC: UIViewController {
    
    
    weak var delegate: HomeViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Home"
        configureUI()
    }
    
    func configureUI() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(menuButtonTapped))
    }
    
    @objc private func menuButtonTapped() {
        delegate?.didTapMenuButton()
    }
}
