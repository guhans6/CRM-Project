//
//  RecordsTableViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import UIKit


class RecordsTableViewController: UITableViewController {
    
    private let recordsController = RecordsController()
    private var formViewController: FormTableViewController!
    private var module: Module?
    private var moduleApiName: String
    private var isLookUp: Bool
    private var records = [Record]()
    var delegate: RecordTableViewDelegate?
    
    // This init is for when module is availabe when called
    init(module: Module, isLookUp: Bool) {
        
        self.module = module
        self.moduleApiName = module.apiName
        self.isLookUp = isLookUp
        super.init(nibName: nil, bundle: nil)
    }
    
    // in lookup 
    init(module: String, isLookup: Bool) {
        
        self.moduleApiName = module
        self.isLookUp = isLookup
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = module?.modulePluralName ?? moduleApiName
        view.backgroundColor = .systemBackground
        
        configureRecordsTableView()
        configureNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecords()
    }
    
    private func configureNavigationBar() {
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewRecordButtonTapped))
        navigationItem.rightBarButtonItem = barButton
        
    }
    
    private func configureRecordsTableView() {
        
        tableView.separatorColor = .tableViewSeperator
        tableView.register(RecordsTableViewCell.self, forCellReuseIdentifier: RecordsTableViewCell.recordCellIdentifier)
    }
    
    private func getRecords() {
        
        tableView.showLoadingIndicator()
        recordsController.getAllRecordsFor(module: moduleApiName) { [weak self] records in
            
            self?.records = records
            self?.tableView.reloadData()
            
            if records.count == 0 {
                
                self?.tableView.hideLoadingIndicator()
                let title = "No \(self?.module?.moduleSingularName ?? "") record found"
                self?.tableView.setEmptyView(title: title, message: "Add a new record")
            } else {
                self?.tableView.restore()
            }
        }
    }
    
    @objc private func addNewRecordButtonTapped() {
        
        if let module {
            formViewController = FormTableViewController(module: module)
        } else {
            formViewController = FormTableViewController(moduleApiName: moduleApiName)
        }

        navigationController?.pushViewController(formViewController, animated: true)
    }
}

extension RecordsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordsTableViewCell.recordCellIdentifier) as! RecordsTableViewCell
        let record = records[indexPath.row]
        cell.configureRecordCell(recordName: record.recordName, secondaryData: record.secondaryRecordData)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let record = records[indexPath.row]
        
        // Checking if it is a lookup, if it is call the delegate method to fill up lookup record
        // Otherwise present the info the record
        if !isLookUp {
            
            if let module {
                
                let individualRecordVC = RecordInfoTableViewController(recordModule: module, recordId: record.recordId)
                let _ = UINavigationController(rootViewController: individualRecordVC)
                navigationController?.pushViewController(individualRecordVC, animated: true)
            }
        } else {
            
            delegate?.setLookupRecordAndId(recordName: record.recordName, recordId: record.recordId)
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
