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
    private let hiddenButton = UIButton()
    
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
            headerImageView.image = UIImage(named: "cameraPlus")
        }
        headerImageView.backgroundColor = .systemGray5
        headerView.addSubview(headerImageView)
        
        // Set up Auto Layout constraints for header image view
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        headerImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        headerImageViewHeightConstraint = headerImageView.heightAnchor.constraint(equalToConstant: imageHeight + 10)
        headerImageViewHeightConstraint?.isActive = true
        headerImageView.widthAnchor.constraint(equalTo: headerImageView.heightAnchor).isActive = true
        
        headerView.addSubview(hiddenButton)
        
//        hiddenButton.frame = headerImageView.frame
        hiddenButton.translatesAutoresizingMaskIntoConstraints = false
        hiddenButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        hiddenButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        hiddenButton.heightAnchor.constraint(equalToConstant: imageHeight + 10).isActive = true
        hiddenButton.widthAnchor.constraint(equalTo: headerImageView.heightAnchor).isActive = true
//        hiddenButton.leadingAnchor.constraint(equalTo: headerImageView.leadingAnchor).isActive = true
//        hiddenButton.topAnchor.constraint(equalTo: headerImageView.topAnchor).isActive = true
//        hiddenButton.trailingAnchor.constraint(equalTo: headerImageView.trailingAnchor).isActive = true
//        hiddenButton.bottomAnchor.constraint(equalTo: headerImageView.bottomAnchor).isActive = true
        hiddenButton.menu = getMenu()
        hiddenButton.showsMenuAsPrimaryAction = true

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
        
        recordsController.getRecordImage(module: moduleApiName, recordId: recordId) { image in
            
            if let image = image {
                self.headerImageView.image = image
            }
        }
        
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

extension RecordInfoTableViewController {
    
    @objc private func didTapImageView() {
        
//        guard let cell = sender.view?.superview?.superview as? ImageTableViewCell else {
//            return
//        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    private func getMenu() -> UIMenu? {

        let selectAction =  UIAction(title: "Select from Photo Library",
                                     image: UIImage(systemName: "photo.on.rectangle.angled"))
        { [weak self] action in
            self?.didTapImageView()
        }
        
        var menu =  UIMenu(title: "Select an option", children: [
            selectAction,
        ])
        
        if headerImageView.image != UIImage(named: "cameraPlus") {
            let removeAction = UIAction(title: "Remove Image",
                                        image: UIImage(systemName: "trash"),
                                        attributes: .destructive)
            { [weak self] action in
                
                guard let self = self else { print("Must Not happen in menu Action"); return }
                self.headerImageView.image = UIImage(named: "cameraPlus")
                
                self.recordsController.deleteImage(module: self.moduleApiName, recordId: self.recordId) { isSuccess in
                    print("imageDeletionSuccessfull", isSuccess)
                }
                self.hiddenButton.menu = self.getMenu()
            }
            
            menu =  UIMenu(title: "Select an option", children: [
                selectAction,
                removeAction
            ])
        }
        return menu
    }
}

extension RecordInfoTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Get the selected image
        guard let pickedImage = info[.editedImage] as? UIImage else {
            print("No image selected")
            return
        }
        
        // Convert image to PNG data representation
        guard let imageData = pickedImage.pngData() else {
            print("Unable to convert image to PNG data")
            return
        }
        
        // Check if image size is within the allowed range (10 MB)
        let allowedSize: Int64 = 10 * 1024 * 1024 // 10 MB
        let imageSize = Int64(imageData.count)
        guard imageSize <= allowedSize else {
            
            // Display an alert to the user
            let alert = UIAlertController(title: "Image Size Exceeded", message: "The selected image size exceeds the allowed size (10 MB). Please select a smaller image.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            picker.dismiss(animated: true)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Check if image resolution is within the allowed range (10 MP)
        let allowedResolution: CGFloat = 10000000 // 10 MP
        let imageResolution = pickedImage.size.width * pickedImage.size.height
        guard imageResolution <= allowedResolution else {
            // Display an alert to the user
            let alert = UIAlertController(title: "Image Resolution Exceeded", message: "The selected image resolution exceeds the allowed resolution (10 MP). Please select a smaller image.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            picker.dismiss(animated: true)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        recordsController.saveImage(image: pickedImage, module: moduleApiName, recordId: recordId) { isSuccess in
            print(isSuccess)
        }
        headerImageView.image = pickedImage
        self.hiddenButton.menu = self.getMenu()
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true)
    }
}
