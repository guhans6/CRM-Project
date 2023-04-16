//
//  IndividualRecordTableViewController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 14/02/23.
//

import UIKit

class RecordInfoTableViewController: UITableViewController {

    private lazy var recordsController: RecordInfoContract = RecordsController()
    private let fieldsController = FieldsController()
    private var formVc: FormTableViewController?
//    private let headerView = RoundedImageViewHeader()
    
    private let recordModule: Module?
    private var moduleApiName: String
    private let recordId: String
    private var headerTitle: String?
    
    private var recordInfo = [(String, Any)]()
    private var fields = [Field]()
    
    private let headerHeight: CGFloat = 160
    private let minHeaderHeight: CGFloat = 80 // Change this to the minimum height you want for the header view
    var imageHeight: CGFloat = 130
    private let headerView = UIView()
    private let headerImageView = UIImageView()
    private var headerImageViewHeightConstraint: NSLayoutConstraint?
    private var recordImage: UIImage?
    
    init(recordModule: Module, recordId: String, recordImage: UIImage?) {
        
        self.recordModule = recordModule
        self.moduleApiName = recordModule.apiName
        self.recordId = recordId
        self.formVc = FormTableViewController(module: recordModule)
        self.recordImage = recordImage
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        
    }
    
    init(recordModule: String, recordId: String, title: String? = nil) {
        
        self.moduleApiName = recordModule
        self.recordId = recordId
        self.headerTitle = title
        self.recordModule = nil
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        UIView.animate(withDuration: 0.5) {
//
//                self.tabBarController?.tabBar.frame.origin.y += self.tabBarController?.tabBar.frame.size.height ?? 0.0
//            }
        getRecord()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        formVc?.delegate = self
//        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.hidesBottomBarWhenPushed = true
        title = recordModule?.moduleSingularName.appending(" Information")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//            UIView.animate(withDuration: 0.5) {
//
//                self.tabBarController?.tabBar.frame.origin.y -= self.tabBarController?.tabBar.frame.size.height ?? 0.0
//            }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
//        UIView.animate(withDuration: 0.5) {
//
//                self.tabBarController?.tabBar.frame.origin.y += self.tabBarController?.tabBar.frame.size.height ?? 0.0
//        }
    }

    private func configureNavigationBar() {
        
        let editButtonImage = UIImage(systemName: "pencil")
        
        let editButton = UIBarButtonItem(image: editButtonImage, style: .plain, target: self, action: #selector(editButtonTapped))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonTapped(_:)))
        
        navigationItem.rightBarButtonItems = [editButton, deleteButton]
    }
    
    private func configureTableView() {
        
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.rowHeight = UITableView.automaticDimension
        
        let safeAreaInset = view.safeAreaInsets.top
        
        // Set up header view
        headerView.frame = CGRect(x: 0, y: -safeAreaInset, width: view.bounds.width, height: headerHeight)
        headerView.backgroundColor = .clear
        headerView.clipsToBounds = true
        tableView.tableHeaderView = headerView
        configureTableHeader()
        
        tableView.register(RecordInfoTableViewCell.self, forCellReuseIdentifier: RecordInfoTableViewCell.recordInfoCellIdentifier)
    }
    
    @objc private func editButtonTapped() {
        
        if let recordModule = recordModule {
            formVc = FormTableViewController(module: recordModule)
        }
        guard let formVc = formVc else {
            print("No formVC this should not happen")
            return
        }
        
        formVc.setUpCellsForEditing(recordId: recordId,
                                    recordData: recordInfo,
                                    recordState: .edit, recordImage: recordImage)
        let navigationVC = UINavigationController(rootViewController: formVc)
        
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
        
    }
    
    private func configureTableHeader() {
        
        // Set up image view
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        headerImageView.layer.cornerRadius = imageHeight / 2
        if let recordImage = recordImage {
            headerImageView.image = recordImage
        } else {
            headerImageView.image = UIImage(named: "camera")
        }
        headerImageView.backgroundColor = .systemGray5
        headerView.addSubview(headerImageView)
        
        // Set up Auto Layout constraints for header image view
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        headerImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        headerImageViewHeightConstraint = headerImageView.heightAnchor.constraint(equalToConstant: imageHeight)
        headerImageViewHeightConstraint?.isActive = true
        headerImageView.widthAnchor.constraint(equalTo: headerImageView.heightAnchor).isActive = true

    }
    
    @objc private func deleteButtonTapped(_ sender: UIBarButtonItem) {
        
        self.navigationController?.navigationItem.rightBarButtonItems?.forEach({ button in
            button.isEnabled = false
        })
        sender.isEnabled = false
        navigationController?.navigationItem.leftBarButtonItem?.isEnabled = false
        var title = "Are you sure want to delete this Record ?"
        if moduleApiName == "Table_Reservations" {
            
            title.append("\nDeleting this record also deletes associated reservations.")
        }
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Delete",
                                                style: .destructive, handler: { [weak self] _ in
            
            guard let self = self else {
                print("Deinitialized somewhere")
                return
            }
            
            self.recordsController.deleteRecords(module: self.moduleApiName,
                                                 ids: [self.recordId]) { [weak self] result in
                
                print("is deleted", result)
                self?.navigationController?.popViewController(animated: true)
                sender.isEnabled = true
                self?.navigationController?.navigationItem.leftBarButtonItem?.isEnabled = true
                self?.navigationController?.navigationItem.rightBarButtonItems?.forEach({ button in
                    button.isEnabled = true
                })
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            
            self?.navigationController?.navigationItem.leftBarButtonItem?.isEnabled = true
            sender.isEnabled = true
            self?.navigationController?.navigationItem.rightBarButtonItems?.forEach({ button in
                button.isEnabled = true
            })
        }))
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {


        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return headerTitle
    }
}

extension RecordInfoTableViewController: FormTableViewDelegate {
    
    func getFields(fields: [Field]) { }
    
    func formView(recordImage: UIImage?) {
        if let recordImage = recordImage {
            self.headerImageView.image = recordImage
        }
    }
}
