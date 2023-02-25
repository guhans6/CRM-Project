//
//  DropDownButton.swift
//  CRM C
//
//  Created by guhan-pt6208 on 24/02/23.
//

import UIKit

protocol dropDownProtocol {
    
    /// Pass the data to the button
    func dropDownPressed(string : String)
}

class DropDownButton: UIView, dropDownProtocol {
    
    
    var tableView = UITableView()
    var dropDownOptions = [String]()
    let button = UIButton()
    var isOpen = false
    
    var delegate : dropDownProtocol?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
//        configureTableView()
        configureButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        
        self.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(btnTouched), for: .touchUpInside)
        

        button.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func configureTableView() {
        
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = UIColor(named: "TableSelect")
        
        self.addSubview(tableView)
//        tableView.isHidden = true
        
        tableView.topAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
    }
    
    
    @objc private func btnTouched() {
        print("touched")
        UIView.animate(withDuration: 0.3) {
            self.tableView.isHidden = false
        }
    }
    
    func dismissDropDown() {
        
    }
    
    func dropDownPressed(string: String) {
        
        self.dismissDropDown()
    }
    
    func setDropDownOptions(options: [String]) {
        self.dropDownOptions = options
    }
}

extension DropDownButton: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {
    
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    
    var delegate : dropDownProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.separatorColor = UIColor(named: "TableSelect")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

}
