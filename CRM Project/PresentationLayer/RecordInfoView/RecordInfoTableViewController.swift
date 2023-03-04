//
//  IndividualRecordTableViewController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 14/02/23.
//

import UIKit

class RecordInfoTableViewController: UITableViewController {

//    var record
    lazy var individualRecordPresenter: RecordInfoPresenterContract = RecordInfoPresenter()
    let recordModule: Module
    let recordId: String
    var recordInfo = [(String, Any)]()
    
    init(recordModule: Module, recordId: String) {
        self.recordModule = recordModule
        self.recordId = recordId
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureTableView()
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.separatorColor = .tableViewSeperator
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRecord()
    }
    
    private func configureTableView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        tableView.register(RecordInfoTableViewCell.self, forCellReuseIdentifier: RecordInfoTableViewCell.recordInfoCellIdentifier)
    }
    
    @objc private func editButtonTapped() {
        
        let formTableVC = FormTableViewController(module: recordModule)
        formTableVC.setUpCellsForEditing(recordid: recordId, recordData: recordInfo, recordState: .edit)
        navigationController?.pushViewController(formTableVC, animated: true)
    }
    
    func getRecord() {
        individualRecordPresenter.getRecordFor(id: recordId, module: recordModule.apiName) { [weak self] recordInfo in
            self?.recordInfo = recordInfo
            self?.tableView.reloadData()
            
//            recordInfo.forEach { key, value in
//                print(key, value, separator: "v^^^") 
//            }
        }
    }
    
}

extension RecordInfoTableViewController {  // RecordInfo Delegate and DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordInfoTableViewCell.recordInfoCellIdentifier) as! RecordInfoTableViewCell
        let record = recordInfo[indexPath.row]
//        print(record.0, record.1)
        cell.setUpRecordInfoCell(recordName: record.0, recordData: record.1)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension RecordInfoTableViewController: RecordInfoViewContract {
    
    func displayRecordInfo(of record: [(String, String)]) {
        self.recordInfo = record
        self.tableView.reloadData()
    }
    
}
