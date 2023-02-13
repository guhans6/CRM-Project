//
//  LookUpTableViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 13/02/23.
//

import UIKit

class LookupTableViewController: RecordsTableViewController {
    
    var delegate: LookupTableViewDelegate?
    
    override init(module: String) {
        super.init(module: module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    deinit {
        print("deinit time:\(Date())")
    }
    
    
}


extension LookupTableViewController {
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let record = records[indexPath.row]
        delegate?.getLookupRecordId(recordName: record.recordName, recordId: record.recordId)
        navigationController?.popViewController(animated: true)
    }
}
