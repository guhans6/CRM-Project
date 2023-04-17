//
//  RecordsTableViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import UIKit


class RecordsTableViewController: UIViewController {
    
    private let recordsController: RecordsContract = RecordsController()
    private let imageController: ImageDownloadController  = ImageDownloadController()
    private var formViewController: FormTableViewController!
    private let searchController = UISearchController()
    private let refreshControl = UIRefreshControl()
    private var module: Module?
    private var moduleApiName: String
    private var isLookUp: Bool = false
    private var records = [Record]()
    private var filteredRecords = [Record]()
    
    private var isSearching = false
    private var isFiltered = false
    private var isVCPushed = false
    private var isLoading = true
    
    weak var delegate: RecordTableViewDelegate?
    
    private var tableView: UITableView!
    private var sortedRecords = [String: [Record]]()
    private var sectionTitles = [String]()
    
    // This init is for when module is availabe when called
    init(module: Module) {
        
        self.module = module
        self.moduleApiName = module.apiName
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
        
        if isLookUp {
            configureNavigationBar()
        }
        configureRecordsTableView()
//        getRecords()
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.tabBar.isHidden = false
        tableView.showLoadingIndicator()
        if isVCPushed == true {
            
            isVCPushed = false
        }
        getRecords()
    }
    
    private func configureNavigationBar() {
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewRecordButtonTapped))
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.rightBarButtonItems = [addButton, sortButton]
        
        DispatchQueue.main.async { [weak self] in
            self?.searchController.searchBar.delegate = self
            self?.searchController.delegate = self
            self?.navigationItem.searchController = self?.searchController
            self?.searchController.searchBar.autocapitalizationType = .none
            self?.navigationItem.hidesSearchBarWhenScrolling = false
        }
        
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
        
        tableView = UITableView(frame: view.bounds)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .tableViewSeperator
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .systemGray6
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.register(RecordsTableViewCell.self, forCellReuseIdentifier: RecordsTableViewCell.recordCellIdentifier)
        tableView.backgroundView = nil
        
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func didPullToRefresh() {
        getRecords()
    }
    
    private func getRecords() {

        var isFromDB = true
        tableView.backgroundView = nil
        if filteredRecords.isEmpty{
            tableView.showLoadingIndicator()
        }
        recordsController.getAllRecordsFor(module: moduleApiName) { [weak self] records in

            self?.records = records
            if self?.isSearching == false {
                self?.filteredRecords = records
            }
            
            self?.tableView.reloadData()

            if self?.records.count ?? 0 > 0 {
                
                self?.tableView.hideLoadingIndicator()
            } else {
                
                if isFromDB == false {
                    let title = "No \(self?.module?.moduleSingularName ?? "") record found"
                    self?.tableView.setEmptyView(title: title,
                                                 message: "Add a new record",
                                                 image: UIImage(named: "records"))
                }
            }
            isFromDB = false
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
}

extension RecordsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if !isFiltered || isSearching {
            return 1
        } else {
            return sectionTitles.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !isFiltered || isSearching {
            return filteredRecords.count
        } else {
            
            let sectionTitle = sectionTitles[section]
            return sortedRecords[sectionTitle]?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordsTableViewCell.recordCellIdentifier) as! RecordsTableViewCell
        
        cell.tag = indexPath.row
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let record = records[indexPath.row]
        
        // Checking if it is a lookup, if it is call the delegate method to fill up lookup record
        // Otherwise present the info the record
        if !isLookUp {
            
            if let module {
                
                let individualRecordVC = RecordInfoTableViewController(recordModule: module, recordId: record.recordId, recordImage: record.recordImage)
//                let _ = UINavigationController(rootViewController: individualRecordVC)
                navigationController?.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(individualRecordVC, animated: true)
//                present(individualRecordVC, animated: true)
                isVCPushed = true
            }
        } else {
            
            delegate?.setLookupRecordAndId(recordName: record.recordName, recordId: record.recordId)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension RecordsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if !isFiltered || isSearching {
            return nil
        } else {
            return sectionTitles[section]
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
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
