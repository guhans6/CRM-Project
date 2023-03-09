//
//  RecordsTableViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import UIKit


class RecordsTableViewController: UITableViewController {
    
    private let recordsController = RecordsController()
    private var module: Module?
    private var moduleName: String?
    private var moduleApiName: String!
    private var isLookUp: Bool
    var delegate: RecordTableViewDelegate?
    var records = [Record]()
    
    // This init is for when module is availabe when called
    init(module: Module, isLookUp: Bool) {
        
        self.module = module
        self.isLookUp = isLookUp
        super.init(nibName: nil, bundle: nil)
        getRecords()
    }
    
    // in lookup 
    init(module: String, isLookup: Bool) {
        
        self.moduleName = module
        self.isLookUp = isLookup
        super.init(nibName: nil, bundle: nil)
        getRecords()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let module {
            moduleApiName = module.apiName
        } else if let moduleName {
            moduleApiName = moduleName
        }
        
        title = module?.modulePluralName ?? moduleApiName
        view.backgroundColor = .systemBackground
        
        tableView.separatorColor = .tableViewSeperator
        
        configureRecordsTableView()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewRecordButtonTapped))
        
    }
    
    private func configureRecordsTableView() {
        
        tableView.register(RecordsTableViewCell.self, forCellReuseIdentifier: RecordsTableViewCell.recordCellIdentifier)
    }
    
    private func getRecords() {
        
        tableView.showLoadingIndicator()
        RecordsController().getAllRecordsFor(module: moduleApiName) { [weak self] records in
            
            self?.records = records
            
            if records.count == 0 {
                
                let title = "No \(self?.module?.moduleSingularName ?? "") record found"
                self?.tableView.setEmptyView(title: title, message: "Add a new record")
            } else {
                
                self?.tableView.reloadData()
            }
            self?.tableView.hideLoadingIndicator()
        }
    }
    
    @objc private func addNewRecordButtonTapped() {
        
        var formViewController: FormTableViewController!
        
        if let module {
            formViewController = FormTableViewController(module: module)
        } else if let moduleName {
            formViewController = FormTableViewController(moduleApiName: moduleName)
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if isLookUp == false {
            
            let swipeConfiguration = UIContextualAction(style: .destructive, title: "Delete") { action, view, complete in
                
                let record = self.records.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                self.recordsController.deleteRecords(module: self.moduleApiName, ids: [record.recordId]) { result in
                    
                }
                complete(true)
            }
            return UISwipeActionsConfiguration(actions: [swipeConfiguration])
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        if isLookUp {
            return .delete
        }
        return .none
    }
}
