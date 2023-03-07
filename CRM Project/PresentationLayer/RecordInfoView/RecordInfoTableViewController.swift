//
//  IndividualRecordTableViewController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 14/02/23.
//

import UIKit

class RecordInfoTableViewController: UITableViewController {

//    var record
    private lazy var individualRecordPresenter = RecordInfoPresenter()
    private var formVc: FormTableViewController
    private let recordModule: Module
    private let recordId: String
    private var recordInfo = [(String, Any)]()
    
    init(recordModule: Module, recordId: String) {
        self.recordModule = recordModule
        self.recordId = recordId
        self.formVc = FormTableViewController(module: recordModule)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
//        formVc.delegate = self
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
        
        formVc.setUpCellsForEditing(recordid: recordId, recordData: recordInfo, recordState: .edit)
        navigationController?.pushViewController(formVc, animated: true)
    }
    
    func getRecord() {
        
        tableView.showLoadingIndicator()
        individualRecordPresenter.getRecordFor(id: recordId, module: recordModule.apiName) { [weak self] recordInfo in
            self?.recordInfo = recordInfo
            
            if self?.recordInfo.count ?? 0 > 0 {
                
                self?.tableView.hideLoadingIndicator()
                self?.tableView.reloadData()
            } else {
                
                self?.tableView.hideLoadingIndicator()
                self?.tableView.setEmptyView(title: "Empty Record Data", message: "")
            }

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
