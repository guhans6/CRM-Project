//
//  ViewController.swift
//  ProfileCollecitonViewPractice
//
//  Created by guhan-pt6208 on 31/03/23.
//

import UIKit

class RecordsCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    private let recordsController: RecordsContract = RecordsController()
    private var formViewController: FormTableViewController!
    private let searchController = UISearchController()
    private var module: Module?
    private var moduleApiName: String
    private var isLookUp: Bool
    private var records = [Record]()
    private var filteredRecords = [Record]()
    
    private var sortedRecords = [String: [Record]]()
    private var sectionTitles = [String]()
    
    private var isSearching = false
    private var isFiltered = false
    private var isVCPushed = false
    
    private lazy var viewheight = view.frame.height < view.frame.width ? view.frame.width : view.frame.height
    private lazy var viewWidth = view.frame.width > view.frame.height ? view.frame.height : view.frame.width

    private var collectionView: UICollectionView!
    
    init(module: Module, isLookUp: Bool) {
        
        self.module = module
        self.moduleApiName = module.apiName
        self.isLookUp = isLookUp
//        super.init(collectionViewLayout: UICollectionViewLayout())
        super.init(nibName: nil, bundle: nil)
    }
    
    // in lookup
    init(moduleName: String, isLookup: Bool) {
        
        self.moduleApiName = moduleName
        self.isLookUp = isLookup
//        super.init(collectionViewLayout: UICollectionViewLayout())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = module?.modulePluralName ?? moduleApiName
        
//        configureNavigationBar()
        configureCollectionView()
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        if isVCPushed == true {
            
            isVCPushed = false
            
        }
//        navigationController?.navigationBar.prefersLargeTitles = true
        
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        searchController.searchBar.delegate = self
//        searchController.delegate = self
//        navigationItem.searchController = searchController
//
//        searchController.searchBar.autocapitalizationType = .none
    }
    
    private func configureNavigationBar() {
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewRecordButtonTapped))
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.rightBarButtonItems = [addButton, sortButton]
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
    
    private func configureCollectionView() {
        
        view.backgroundColor = .systemBackground
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (viewWidth/3)-5, height: (viewWidth/2)-5)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        collectionView.register(RecordCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecordCollectionViewCell.identifier)
        collectionView.register(RecordHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecordHeaderView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func getRecords() {
        
        sectionTitles = []
        sortedRecords = [:]
        collectionView.showLoadingIndicator()
        recordsController.getAllRecordsFor(module: moduleApiName) { [weak self] records in
            
            self?.records = records
            if self?.isSearching == false {
                self?.filteredRecords = records
            }
            self?.collectionView.hideLoadingIndicator()
            self?.collectionView.reloadData()

            if records.count == 0 {
                
                self?.collectionView.hideLoadingIndicator()
                let title = "No \(self?.module?.moduleSingularName ?? "") record found"
                self?.collectionView.setEmptyView(title: title,
                                             message: "Add a new record",
                                             image: UIImage(named: "records"))
            } else {
                self?.collectionView.restore()
            }
        }
    }
    
    func setRecords(records: [Record]) {
        
        self.records = records
        if self.isSearching == false {
            self.filteredRecords = records
        }
        reloadData()
    }
    
    func reloadData() {
        if let collectionView = collectionView {
            collectionView.reloadData()
        }
    }
    
    func setEmptyView() {
        
        let title = "No \(module?.moduleSingularName ?? "") record found"
        collectionView.setEmptyView(title: title,
                                     message: "Add a new record",
                                     image: UIImage(named: "records"))
    }
}

extension RecordsCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if !isFiltered || isSearching {
            return 1
        } else {
            return sectionTitles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if !isFiltered || isSearching {
            return filteredRecords.count
        } else {
            
            let sectionTitle = sectionTitles[section]
            return sortedRecords[sectionTitle]?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordCollectionViewCell.identifier, for: indexPath) as! RecordCollectionViewCell
        
        let record: Record!
        if !isFiltered || isSearching {
            
            record = filteredRecords[indexPath.row]
        } else {
            
            record = sortedRecords[sectionTitles[indexPath.section]]![indexPath.row]
        }
        
        if let recordImage = record.recordImage {
            cell.imageview.image = recordImage
        }
        cell.name.text = record.recordName
        cell.secondaryLabel.text = record.secondaryRecordData
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let record = records[indexPath.row]
        
        // Checking if it is a lookup, if it is call the delegate method to fill up lookup record
        // Otherwise present the info the record
        if !isLookUp {
            
            if let module {
                
                let individualRecordVC = RecordInfoTableViewController(recordModule: module, recordId: record.recordId, recordImage: record.recordImage)
                navigationController?.pushViewController(individualRecordVC, animated: true)
//                present(individualRecordVC, animated: true)

                isVCPushed = true
            }
        } else {
            
//            delegate?.setLookupRecordAndId(recordName: record.recordName, recordId: record.recordId)
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RecordsCollectionViewController: UICollectionViewDelegate {
    
    // Set the size of the header
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        if isFiltered {
            return CGSize(width: collectionView.bounds.width, height: 50)
        } else {
            return CGSize.zero
        }
    }
    
    // Set the view for the header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecordHeaderView.identifier, for: indexPath) as! RecordHeaderView
            
            if !isFiltered || isSearching {
                headerView.titleLabel.text = nil
            } else {
                headerView.titleLabel.text = sectionTitles[indexPath.section]
            }
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    // Set the titles for the section index
    func sectionIndexTitles(for collectionView: UICollectionView) -> [String]? {
        if !isFiltered || isSearching {
            return nil
        } else {
            return sectionTitles
        }
    }
}

extension RecordsCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredRecords = []
        if searchText == "" {
            
            collectionView.restore()
            isSearching = false
            filteredRecords = records
        } else {
            
            collectionView.restore()
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
            
            collectionView.setEmptyView(title: "No search Results for \"\(searchText)\"",
                                   message: "",
                                   image: UIImage(named: "search"),
                                   shouldImageAnimate: true)
        }
        collectionView.reloadData()
    }
}

extension RecordsCollectionViewController: UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        
        isSearching = false
        collectionView.restore()
        filteredRecords = records
        collectionView.reloadData()
    }
}

extension RecordsCollectionViewController: PickerViewDelegate {
    
    func pickerViewData(datePickerDate: Date, tableviewSelectedRow: String) {
        
        let sortMethod = tableviewSelectedRow
        if sortMethod != "Normal" {
            isFiltered = true
            recordsController.sortRecords(records: records, sortMethod: sortMethod) { [weak self] sectionData, sectionTitles in
                
                self?.sectionTitles  = sectionTitles
                self?.sortedRecords = sectionData
                collectionView.reloadData()
            }
        } else {
            
            isFiltered = false
            collectionView.reloadData()
        }
    }
}
