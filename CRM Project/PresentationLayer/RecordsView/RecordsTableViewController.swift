//
//  RecordsTableViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import UIKit


class RecordsTableViewController: UITableViewController {
    
    private let recordsController: RecordsContract = RecordsController()
    private var formViewController: FormTableViewController!
    private let searchController = UISearchController()
    private var module: Module?
    private var moduleApiName: String
    private var isLookUp: Bool
    private var records = [Record]()
    private var filteredRecords = [Record]()
    
    private var isSearching = false
    private var isFiltered = false
    private var isVCPushed = false
    
    var delegate: RecordTableViewDelegate?
    
    private var sortedRecords = [String: [Record]]()
    private var sectionTitles = [String]()
    
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
        view.backgroundColor = .systemGray6
        
        configureNavigationBar()
        configureRecordsTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        if isVCPushed == true {
            
            isVCPushed = false
            
            UIView.animate(withDuration: 0.5) {

                self.tabBarController?.tabBar.frame.origin.y -= self.tabBarController?.tabBar.frame.size.height ?? 0.0
            }
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        
        getRecords()
    }
    
    private func configureNavigationBar() {
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewRecordButtonTapped))
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.rightBarButtonItems = [addButton, sortButton]
        
        searchController.searchBar.delegate = self
        searchController.delegate = self
        navigationItem.searchController = searchController

        searchController.searchBar.autocapitalizationType = .none
    }
    
    @objc private func sortButtonTapped() {
        
        let pickerVc = PickerViewController(tablviewData: ["Normal", "ASC", "DSC"], headerTitle: "Sort By")
        pickerVc.delegate = self
        pickerVc.showView(viewType: .tableView)
        if let sheetController = pickerVc.sheetPresentationController {
            
            sheetController.prefersGrabberVisible = true
            sheetController.detents = [.medium(), .large()]
            sheetController.prefersEdgeAttachedInCompactHeight = true
        }
        
        present(pickerVc, animated: true)
    }
    
    @objc private func addNewRecordButtonTapped() {
        
        if let module {
            formViewController = FormTableViewController(module: module)
        } else {
            formViewController = FormTableViewController(moduleApiName: moduleApiName)
        }

        let navigationVC = UINavigationController(rootViewController: formViewController)
        navigationVC.modalPresentationStyle = .fullScreen
        
        present(navigationVC, animated: true)
    }
    
    private func configureRecordsTableView() {
        
        
        tableView.separatorColor = .tableViewSeperator
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .systemGray6
        tableView.register(RecordsTableViewCell.self, forCellReuseIdentifier: RecordsTableViewCell.recordCellIdentifier)
    }
    
    private func getRecords() {
        
        sectionTitles = []
        sortedRecords = [:]
        tableView.showLoadingIndicator()
        recordsController.getAllRecordsFor(module: moduleApiName) { [weak self] records in
            
            self?.records = records
            if self?.isSearching == false {
                self?.filteredRecords = records
            }
            self?.tableView.reloadData()

            if records.count == 0 {
                
                let title = "No \(self?.module?.moduleSingularName ?? "") record found"
                self?.tableView.setEmptyView(title: title,
                                             message: "Add a new record",
                                             image: UIImage(named: "records"))
            } else {
                self?.tableView.restore()
            }
        }
    }
}

extension RecordsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if !isFiltered || isSearching {
            return 1
        } else {
            return sectionTitles.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !isFiltered || isSearching {
            return filteredRecords.count
        } else {
            
            let sectionTitle = sectionTitles[section]
            return sortedRecords[sectionTitle]?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordsTableViewCell.recordCellIdentifier) as! RecordsTableViewCell
        
        let record: Record!
        if !isFiltered || isSearching {
            
            record = filteredRecords[indexPath.row]
        } else {
            
            record = sortedRecords[sectionTitles[indexPath.section]]![indexPath.row]
        }
        
        cell.configureRecordCell(recordName: record.recordName,
                                 secondaryData: record.secondaryRecordData,
                                 recordImage: record.recordImage)
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
//                let _ = UINavigationController(rootViewController: individualRecordVC)
                navigationController?.pushViewController(individualRecordVC, animated: true)
                UIView.animate(withDuration: 0.5) {

                        self.tabBarController?.tabBar.frame.origin.y += self.tabBarController?.tabBar.frame.size.height ?? 0.0
                    }
                isVCPushed = true
            }
        } else {
            
            delegate?.setLookupRecordAndId(recordName: record.recordName, recordId: record.recordId)
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension RecordsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredRecords = []
        if searchText == "" {
            
            tableView.restore()
            isSearching = false
            filteredRecords = records
        } else {
            
            tableView.restore()
            isSearching = true
            filteredRecords = records.filter { record in
                
                if let _ = record.recordName.range(of: searchText, options: .caseInsensitive) {
                    
                    return true
                } else if let _ = record.secondaryRecordData.range(of: searchText, options: .caseInsensitive) {
                    
                    return true
                }
                return false
            }
        }
        if filteredRecords.isEmpty {
            
            tableView.setEmptyView(title: "No search Results for \"\(searchText)\"",
                                   message: "",
                                   image: UIImage(named: "search"),
                                   shouldImageAnimate: true)
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if !isFiltered || isSearching {
            return nil
        } else {
            return sectionTitles[section]
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        if !isFiltered || isSearching {
            return nil
        } else {
            return sectionTitles
        }
    }
}

extension RecordsTableViewController: UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        
        isSearching = false
        tableView.restore()
        filteredRecords = records
        tableView.reloadData()
    }
}

extension RecordsTableViewController: PickerViewDelegate {
    
    func pickerViewData(datePickerDate: Date, tableviewSelectedRow: String) {
        
        let sortMethod = tableviewSelectedRow
        if sortMethod != "Normal" {
            isFiltered = true
            recordsController.sortRecords(records: records, sortMethod: sortMethod) { [weak self] sectionData, sectionTitles in
                
                self?.sectionTitles  = sectionTitles
                self?.sortedRecords = sectionData
                tableView.reloadData()
            }
        } else {
            
            isFiltered = false
            tableView.reloadData()
        }
    }
}
