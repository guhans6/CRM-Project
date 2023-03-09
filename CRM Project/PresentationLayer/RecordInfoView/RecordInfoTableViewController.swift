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
    private var formVc: FormTableViewController?
    
    private let recordModule: Module?
    private var moduleApiName: String?
    private let recordId: String
    
    private var recordInfo = [(String, Any)]()
    private var fields = [Field]()
    
    init(recordModule: Module, recordId: String) {
        
        self.recordModule = recordModule
        self.recordId = recordId
        self.formVc = FormTableViewController(module: recordModule)
        super.init(nibName: nil, bundle: nil)
        getRecord()
        
    }
    
    init(recordModule: String, recordId: String) {
        
        self.moduleApiName = recordModule
        self.recordId = recordId
        self.recordModule = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        configureTableView()
        
        if title != nil {
            title = recordModule?.moduleSingularName.appending(" Information")
        }
        
        getRecord()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
    private func configureTableView() {
        
        
        if recordModule != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        }
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .insetGrouped)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        tableView.register(RecordInfoTableViewCell.self, forCellReuseIdentifier: RecordInfoTableViewCell.recordInfoCellIdentifier)
        
        
    }
    
    @objc private func editButtonTapped() {
        
        guard let formVc = formVc else {
            print("No formVC this should not happen")
            return
        }
        
        formVc.setUpCellsForEditing(recordid: recordId, recordData: recordInfo, recordState: .edit)
        navigationController?.pushViewController(formVc, animated: true)
    }
    
    private func getRecord() {
        
        tableView.showLoadingIndicator()
        
        var module: String!
        
        if let recordModule = recordModule {
            module = recordModule.apiName
        } else {
            module = moduleApiName
        }
        
        individualRecordPresenter
            .getRecordFor(id: recordId, module: module) { [weak self] recordInfo in
            
            self?.recordInfo = recordInfo
            
            if self?.recordInfo.count ?? 0 > 0 {
                
                self?.tableView.hideLoadingIndicator()
                self?.tableView.reloadData()
            } else {
                
                self?.tableView.hideLoadingIndicator()
                self?.tableView.setEmptyView(title: "Empty Record Data", message: "")
            }
        }
        
        FieldsController().getfields(module: module) { fields in
            self.fields = fields
            self.tableView.reloadData()
        }
    }
    
}

extension RecordInfoTableViewController {  // RecordInfo Delegate and DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // MARK: THIS IS NOT GOOD SHOULD BE DYNAMIC
        return fields.count - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordInfoTableViewCell.recordInfoCellIdentifier) as! RecordInfoTableViewCell
        
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
            return
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
