//
//  IndividualRecordTableViewController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 14/02/23.
//

import UIKit

class RecordInfoTableViewController: UITableViewController {

    private lazy var recordsController = RecordsController()
    private let fieldsController = FieldsController()
    private var formVc: FormTableViewController?
    
    private let recordModule: Module?
    private var moduleApiName: String
    private let recordId: String
    
    private var recordInfo = [(String, Any)]()
    private var fields = [Field]()
    
    init(recordModule: Module, recordId: String) {
        
        self.recordModule = recordModule
        self.moduleApiName = recordModule.apiName
        self.recordId = recordId
        self.formVc = FormTableViewController(module: recordModule)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    init(recordModule: String, recordId: String, title: String? = nil) {
        
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
        
        title = recordModule?.moduleSingularName.appending(" Information")
    }
    
    private func configureNavigationBar() {
        
        let editButtonImage = UIImage(systemName: "square.and.pencil")
        
        let editButton = UIBarButtonItem(image: editButtonImage, style: .plain, target: self, action: #selector(editButtonTapped))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonTapped))
        
        navigationItem.rightBarButtonItems = [editButton, deleteButton]
    }
    
    private func configureTableView() {
        
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        
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
    
    @objc private func deleteButtonTapped() {
        
        let alertController = UIAlertController(title: "Are you sure want to delete this Record ?", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Delete",
                                                style: .destructive, handler: { [weak self] _ in
            
            guard let self = self else {
                print("Deinitialized somewhere")
                return
            }
            
            self.recordsController.deleteRecords(module: self.moduleApiName, ids: [self.recordId]) { result in
                
                self.navigationController?.popViewController(animated: true)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    private func getRecord() {
        
        tableView.showLoadingIndicator()
        
        recordsController.getIndividualRecords(module: moduleApiName,
                                               id: recordId) { [weak self] recordInfo in
            
            self?.recordInfo = recordInfo
            
            if self?.recordInfo.count ?? 0 > 0 {
                
                self?.tableView.hideLoadingIndicator()
                self?.configureNavigationBar()
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
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//
//        return UITableView.automaticDimension
//    }
//
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let cell = tableView.cellForRow(at: indexPath)
//        print(cell?.bounds.height)
        print(tableView.rowHeight)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return nil
    }
}
