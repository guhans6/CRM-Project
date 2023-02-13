//
//  LookUpTableViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 13/02/23.
//

import UIKit

class LookupTableViewController: UITableViewController {
    
    let lookUpTableViewPresenter = LookupPresenter()
    let moduleType: ModuleType
    var records = [Record]()
    
    init(module: ModuleType) {
        self.moduleType = module
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func configureTableView() {
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func getLookUpRecords() {
        lookUpTableViewPresenter.displayLookUPRecords(for: self.moduleType.rawValue) { records in
            self.records = records
            self.tableView.reloadData()
        }
    }

}


extension LookupTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
