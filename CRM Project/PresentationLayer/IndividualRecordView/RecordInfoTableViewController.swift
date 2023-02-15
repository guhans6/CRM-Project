//
//  IndividualRecordTableViewController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 14/02/23.
//

import UIKit

class RecordInfoTableViewController: UITableViewController {

//    var record
    lazy var individualRecordPresenter = RecordInfoPresenter()
    let recordModule: String
    let recordId: String
    var recordInfo = [(String, Any)]()
    
    init(recordModule: String, recordId: String) {
        self.recordModule = recordModule
        self.recordId = recordId
        super.init(nibName: nil, bundle: nil)
        
        configureTableView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        tableView.register(RecordInfoTableViewCell.self, forCellReuseIdentifier: RecordInfoTableViewCell.recordInfoCellIdentifier)
        getRecord()
    }
    
    @objc private func editButtonTapped() {
        
    }
    
    func getRecord() {
        individualRecordPresenter.getRecordFor(id: recordId, module: recordModule) { recordInfo in
            self.recordInfo = recordInfo
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordInfoTableViewCell.recordInfoCellIdentifier) as! RecordInfoTableViewCell
        let record = recordInfo[indexPath.row]
        let recordData = record.1 as? String ?? ""
        print(record.0, recordData)
        cell.setUpRecordInfoCell(recordName: record.0, recordData: recordData)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
