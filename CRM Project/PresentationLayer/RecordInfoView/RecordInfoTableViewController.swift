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
    private let fieldsController = FieldsController()
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
    
    override func viewWillAppear(_ animated: Bool) {
        getRecord()
    }
    
    override func viewDidLoad() {
        
        configureTableView()
        
        if title != nil {
            title = recordModule?.moduleSingularName.appending(" Information")
        }
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
    private func configureTableView() {
        
        
        if recordModule != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        }
        
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .none
        
        
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
    }
    
}

extension RecordInfoTableViewController {  // RecordInfo Delegate and DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // MARK: THIS IS NOT GOOD SHOULD BE DYNAMIC
        return recordInfo.count - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordInfoTableViewCell.recordInfoCellIdentifier) as! RecordInfoTableViewCell
        
        let record = recordInfo[indexPath.row]
        cell.setUpRecordInfoCell(recordName: record.0, recordData: record.1)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
