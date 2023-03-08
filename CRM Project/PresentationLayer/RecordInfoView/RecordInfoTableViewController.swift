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
    private var fields = [Field]()
    
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
        
        title = recordModule.moduleSingularName.appending(" Information")
//        navigationItem.largeTitleDisplayMode = .never
        tableView.separatorStyle = .none
//        tableView.separatorColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRecord()
    }
    
    private func configureTableView() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        tableView.register(RecordInfoTableViewCell.self, forCellReuseIdentifier: RecordInfoTableViewCell.recordInfoCellIdentifier)
    }
    
    @objc private func editButtonTapped() {
        
        formVc.setUpCellsForEditing(recordid: recordId, recordData: recordInfo, recordState: .edit)
        navigationController?.pushViewController(formVc, animated: true)
    }
    
    private func getRecord() {
        
        tableView.showLoadingIndicator()
        individualRecordPresenter.getRecordFor(id: recordId,
                                               module: recordModule.apiName)
        { [weak self] recordInfo in
            
            self?.recordInfo = recordInfo
            
            if self?.recordInfo.count ?? 0 > 0 {
                
                self?.tableView.hideLoadingIndicator()
                self?.tableView.reloadData()
            } else {
                
                self?.tableView.hideLoadingIndicator()
                self?.tableView.setEmptyView(title: "Empty Record Data", message: "")
            }
        }
        
        FieldsController().getfields(module: recordModule.apiName) { fields in
            self.fields = fields
            self.tableView.reloadData()
        }
    }
    
}

extension RecordInfoTableViewController {  // RecordInfo Delegate and DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return recordInfo.count
        return fields.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordInfoTableViewCell.recordInfoCellIdentifier) as! RecordInfoTableViewCell
//        let record = recordInfo[indexPath.row]
//
//        cell.setUpRecordInfoCell(recordName: record.0, recordData: record.1)
        
        let field = fields[indexPath.row]
        var recordData = ""
        
        recordInfo.forEach { key, value in
            
            
            if field.fieldLabel == key || field.apiName == key {
                
                if let value =  value as? String {
                    recordData = value
                    
                } else if let value = value as? [String] {
                    recordData = value[1]
                    
                } else if let value = value as? Double {
                    recordData = String(value)
                    
                } else if let value = value as? Int {
                    
                    recordData = String(value)
                }
            }
        }
        
        cell.setUpRecordInfoCell(recordName: field.fieldLabel, recordData: recordData)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
