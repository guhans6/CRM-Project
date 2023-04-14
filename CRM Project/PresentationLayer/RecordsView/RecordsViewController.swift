//
//  RecordsTableView.swift
//  CRM C
//
//  Created by guhan-pt6208 on 03/04/23.
//

import UIKit

class RecordsViewController: UIViewController {
    
    private let recordsController: RecordsContract = RecordsController()
    private var formViewController: FormTableViewController!
    private let searchController = UISearchController()
    private var barButton: UIBarButtonItem!
    
    private var module: Module
    private var moduleApiName: String
    private var isLookUp: Bool
    private var records = [Record]()
    private var filteredRecords = [Record]()
    
    private lazy var collectionView = RecordsCollectionViewController(module: module, isLookUp: isLookUp)
    private lazy var tableview = RecordsTableViewController(module: module)
    
    private enum RecordViews {
        case tableView
        case collectionView
    }
    
    private var currentView: RecordViews  {
        
        if UserDefaultsManager.shared.isLastPickedViewGrid() {
            return .collectionView
        } else {
            return .tableView
        }
    }
    
    private var sortedRecords = [String: [Record]]()
    private var sectionTitles = [String]()
    
    private var isSearching = false
    private var isFiltered = false
    private var isVCPushed = false
    
    init(module: Module, isLookUp: Bool) {
        
        self.module = module
        self.moduleApiName = module.apiName
        self.isLookUp = isLookUp
//        super.init(collectionViewLayout: UICollectionViewLayout())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        getRecords()
    }
    
    override func viewDidLoad() {

        view.backgroundColor = .systemGray6
        title = module.modulePluralName
        configureNavigationBar()
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        searchController.searchBar.isHidden = false
    }
    
    private func configureView() {
        
        addChild(tableview)
        addChild(collectionView)
        
        // Add the table view as the initial child view controller:
        if currentView == .collectionView {
            view.addSubview(collectionView.view)
            collectionView.didMove(toParent: self)
        } else {
            
            view.addSubview(tableview.view)
            tableview.didMove(toParent: self)
        }
    }
    
    private func getMenu() -> UIMenu {
        
        let tableViewSwitch =   UIAction(title: "List View",
                                     image: UIImage(systemName: "list.bullet"),
                                         state: currentView == .collectionView ? .off : .on,
                                     handler: { _ in
            
            if self.currentView == .collectionView {
                self.switchToTableView()
            }
        })
        
        let collectionViewSwitch = UIAction(title: "Grid View",
                                            image: UIImage(systemName: "square.grid.2x2"),
                                            state: currentView == .collectionView ? .on : .off,
                                            handler: { _ in
            
            if self.currentView == .tableView {
                self.switchToCollectionView()
            }
        })
        
        let sortBy = UIAction(title: "Sort By",
                                       image: UIImage(systemName: "arrow.up.arrow.down"),
                                       handler: { [weak self] _ in
       
            self?.sortButtonTapped()
        })

        let viewMenu = UIMenu(title: "View Options", options: .displayInline, children: [
            tableViewSwitch,
            collectionViewSwitch,

        ])
        
        let menu = UIMenu(title: "", children: [viewMenu, sortBy])
        return menu
    }
    
    private func configureNavigationBar() {
        
        barButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: getMenu())
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewRecordButtonTapped))
        
        navigationItem.rightBarButtonItems = [barButton, addButton]
        
        searchController.searchBar.delegate = self
        searchController.delegate = self
        navigationItem.searchController = searchController
//        searchController.searchBar.isHidden = true
//        tableview.reloadData()
//        collectionView.reloadData()
        navigationItem.hidesSearchBarWhenScrolling = false

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
        
        formViewController = FormTableViewController(module: module)

        let navigationVC = UINavigationController(rootViewController: formViewController)
        navigationVC.modalPresentationStyle = .fullScreen
        
        present(navigationVC, animated: true)
    }
    
    private func switchToTableView() {
        // Replace the current child view controller with the table view:
        addChild(tableview)
        transition(from: collectionView, to: tableview, duration: 0.5, options: .transitionCrossDissolve, animations: nil) { [weak self] _ in
            
            self?.collectionView.removeFromParent()
            self?.tableview.didMove(toParent: self)
            UserDefaultsManager.shared.setLastPickedView(equalTo: false)
            self?.barButton?.menu = self?.getMenu()
//            self?.currentView = .tableView
        }
    }
    
    private func switchToCollectionView() {
        // Replace the current child view controller with the collection view:
        addChild(collectionView)
        transition(from: tableview, to: collectionView, duration: 0.5, options: .transitionCrossDissolve, animations: nil) { [weak self] _ in
            
            self?.tableview.removeFromParent()
            self?.collectionView.didMove(toParent: self)
            UserDefaultsManager.shared.setLastPickedView(equalTo: true)
            self?.barButton?.menu = self?.getMenu()
//            self?.currentView = .collectionView
        }
    }
    
//    private func getRecords() {
//        
//        sectionTitles = []
//        sortedRecords = [:]
//        
//        if currentView == .tableView {
//            tableview.showLoadingIndicator()
//        } else {
//            collectionView.showLoadingIndicator()
//        }
//        recordsController.getAllRecordsFor(module: moduleApiName) { [weak self] records in
//            
////            self?.records = records
////            if self?.isSearching == false {
////                self?.filteredRecords = records
////            }
//            self?.setUpRecordsInView(records: records)
////            self?.collectionView.hideLoadingIndicator()
////            self?.collectionView.reloadData()
//
//            if self?.currentView == .collectionView {
//                self?.collectionView.stopLoadingIndicator()
//            } else {
//                self?.tableview.stopLoadingIndicator()
//            }
//            if records.count == 0 {
//                
//                if self?.currentView == .collectionView {
//                    self?.collectionView.setEmptyView()
//                } else {
//                    self?.tableview.setEmptyView()
//                }
//               
//            } else {
//                self?.collectionView.restore()
//            }
//        }
//    }
    
    private func setUpRecordsInView(records: [Record]) {
        
//        if currentView == .collectionView {
//            
//            collectionView.setRecords(records: records)
//        } else {
//            tableview.setRecords(records: records)
//        }
    }
}

extension RecordsViewController: PickerViewDelegate {
    
    func pickerViewData(datePickerDate: Date, tableviewSelectedRow: String) {
        
        if currentView == .tableView {
            tableview.pickerViewData(datePickerDate: datePickerDate, tableviewSelectedRow: tableviewSelectedRow)
        } else {
            
            collectionView.pickerViewData(datePickerDate: datePickerDate, tableviewSelectedRow: tableviewSelectedRow)
        }
    }
}

extension RecordsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if currentView == .tableView {
            
            tableview.searchBar(searchBar, textDidChange: searchText)
        } else {
            collectionView.searchBar(searchBar, textDidChange: searchText)
        }
    }
}

extension RecordsViewController: UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        
        if currentView == .tableView {
            
            tableview.willDismissSearchController(searchController)
        } else {
            
            collectionView.willDismissSearchController(searchController)
        }
    }
}
