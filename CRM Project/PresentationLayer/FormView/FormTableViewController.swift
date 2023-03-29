//
//  ViewController.swift
//  FormPractice
//
//  Created by guhan-pt6208 on 06/02/23.
//

import UIKit

protocol FormTableViewDelegate {
    
    func getFields(fields: [Field]) -> Void
}

class FormTableViewController: UITableViewController {
    
    private let formController: FieldsContract = FieldsController()
    private let recordsController: AddRecordContract = RecordsController()
    private var fields = [Field]()
    private lazy var editableRecords = [(String, Any)]()
    private var module: Module?
    private var moduleName: String?
    private var fieldData = [Any]()
    var recordsToBeSaved: [(isValid: Bool, data: Any?)?]!
    
    private var recordState: RecordState = .add
    
    enum RecordState {
        
        case add
        case edit
        case editAndUserInteractionDisabled
    }

    private var editingRecordId: String?
    private var moduleApiName: String!
    private lazy var textAreaIndexes = [IndexPath]()
    
    var delegate: FormTableViewDelegate?
    
    init(module: Module) {
        self.module = module
        super.init(nibName: nil, bundle: nil)
        
        setUpController()
        getFields()
    }
    
    init(moduleApiName: String) {
        self.moduleName = moduleApiName
        super.init(nibName: nil, bundle: nil)
        
        setUpController()
        getFields()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureTableView()
        configureNavigationBar()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if recordState == .edit {
            
            title = "Edit ".appending(module?.moduleSingularName ?? moduleApiName)
        } else {
            
            title = "Add ".appending(module?.moduleSingularName ?? moduleApiName)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    private func setUpController() {
        
        if let module {
            
            self.moduleApiName = module.apiName
        } else if let moduleName {
            
            self.moduleApiName = moduleName
        }
    }
    
    private func configureNavigationBar() {
        
        let saveButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(doneButtonClicked))
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonClicked))
        
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @objc private func cancelButtonClicked() {
        
        dismiss(animated: true)
    }
    
    private func configureTableView() {
//        tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.separatorColor = .tableViewSeperator
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        registerTableViewCells()
    }
    
    private func registerTableViewCells() {
        
        tableView.register(EmailTableViewCell.self, forCellReuseIdentifier: EmailTableViewCell.emailCellIdentifier)
        tableView.register(StringTableViewCell.self, forCellReuseIdentifier: StringTableViewCell.stringCellIdentifier)
        tableView.register(IntegerTableViewCell.self, forCellReuseIdentifier: IntegerTableViewCell.integerCellIdentifier)
        tableView.register(DoubleTableViewCell.self, forCellReuseIdentifier: DoubleTableViewCell.doubleCellIdentifier)
        tableView.register(BooleanTableViewCell.self, forCellReuseIdentifier: BooleanTableViewCell.booleanCellIdentifier)
        tableView.register(LookupTableViewCell.self, forCellReuseIdentifier: LookupTableViewCell.lookupCellIdentifier)
        tableView.register(PickListTableViewCell.self, forCellReuseIdentifier: PickListTableViewCell.pickListCellIdentifier)
        tableView.register(TextAreaTableViewCell.self, forCellReuseIdentifier: TextAreaTableViewCell.textAreaCellIdentifier)
        tableView.register(DateTableViewCell.self, forCellReuseIdentifier: DateTableViewCell.dateCellIdentifier)
        
    }
    
    private func getFields() {
        
        formController.getfields(module: moduleApiName) { fields in
            
            self.fields = fields
            self.tableView.reloadData()
            self.delegate?.getFields(fields: fields)
            self.recordsToBeSaved = Array.init(repeating: nil, count: fields.count)
        }
    }
    
    @objc private func doneButtonClicked() {
        
        var data = [String: Any]()
        
        var shouldCancel = false
        
        for index in 0 ..< recordsToBeSaved.count {
            
            let field = fields[index]
            let record = recordsToBeSaved[index]
            if isReadyToSaveOrUpdate(field: field,
                                     recordData: record?.data,
                                     isValidated: record?.isValid ?? true,
                                     cellIndex: index) == false
            {
                shouldCancel = true
                break
            }
            if record?.data != nil && record?.data as? String != "" {
                data[field.apiName] = record?.data
            }
        }
        
        if shouldCancel {
            print("Cancelled")
            return
        }
        
        if editingRecordId != nil {
            
            recordsController.addRecord(module: moduleApiName, recordData: data, isAUpdate: true, recordId: editingRecordId) { [weak self] result in
                
                print("Result is \(result)")
                if result {
                    self?.dismiss(animated: true)
                }
            }
        } else {
            
            recordsController.addRecord(module: moduleApiName, recordData: data, isAUpdate: false, recordId: nil) { [weak self] result in
                
                print("Result is \(result)")
                if result {
                    self?.dismiss(animated: true)
                }
            }
        }
    }

    private func isReadyToSaveOrUpdate(field: Field,
                                       recordData: Any?,
                                       isValidated: Bool,
                                       cellIndex: Int) -> Bool {
        
        let recordData = recordData as? String
        
        if (field.isSystemMandatory && (recordData == "" || recordData == nil)) || isValidated == false {
            
            let cell = tableView.cellForRow(at: IndexPath(row: cellIndex, section: 0)) as! FormTableViewCell
            cell.configureInvalidLabel()
            tableView.beginUpdates()
            tableView.endUpdates()
            return false
        }
        
        return true
    }
}

extension FormTableViewController {
    
    private func getCellFor(indexPath: IndexPath) -> FormTableViewCell {
        
        let field = fields[indexPath.row]
        
        var cell: FormTableViewCell!
        let tapGesture = LookupTapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        
        switch field.dataType {
            
        case "lookup":
            
            cell = tableView.dequeueReusableCell(withIdentifier: LookupTableViewCell.lookupCellIdentifier) as! LookupTableViewCell
            cell?.setLookupName(lookupApiName: field.lookup.module!.apiName)
            cell?.addGestureRecognizer(tapGesture)

        case "email":
            
            cell = tableView.dequeueReusableCell(withIdentifier: EmailTableViewCell.emailCellIdentifier) as! EmailTableViewCell
        case "text":
            
            cell = tableView.dequeueReusableCell(withIdentifier: StringTableViewCell.stringCellIdentifier) as! StringTableViewCell
        case "textarea":
            
            cell = tableView.dequeueReusableCell(withIdentifier: TextAreaTableViewCell.textAreaCellIdentifier) as! TextAreaTableViewCell
            textAreaIndexes.append(indexPath)
            
        case "integer", "phone":
            
            cell = tableView.dequeueReusableCell(withIdentifier: IntegerTableViewCell.integerCellIdentifier) as! IntegerTableViewCell
        case "double", "currency":
            
            cell = tableView.dequeueReusableCell(withIdentifier: DoubleTableViewCell.doubleCellIdentifier) as! DoubleTableViewCell
        case "boolean":
            
            
            cell = tableView.dequeueReusableCell(withIdentifier: BooleanTableViewCell.booleanCellIdentifier) as! BooleanTableViewCell
            
        case "multiselectpicklist", "picklist":
            
            cell = tableView.dequeueReusableCell(withIdentifier: PickListTableViewCell.pickListCellIdentifier) as! PickListTableViewCell
            
            let pickListTapGesuture = LookupTapGestureRecognizer(target: self, action: #selector(pickListTapGesuture(sender:)))
            pickListTapGesuture.row = indexPath.row
            cell?.addGestureRecognizer(pickListTapGesuture)
            
        case "date", "datetime":
            
            cell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.dateCellIdentifier) as! DateTableViewCell
            
            cell?.addGestureRecognizer(tapGesture)
            
        default:
            
            cell = tableView.dequeueReusableCell(withIdentifier: StringTableViewCell.stringCellIdentifier) as! StringTableViewCell
        }
        
        cell?.setUpCellWith(fieldName: field.fieldLabel, isMandatory: field.isSystemMandatory, cellIndex: indexPath.row, fieldType: field.dataType)
        
        return cell
    }
}

extension FormTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fields.count - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let field = fields[indexPath.row]

        let cell = getCellFor(indexPath: indexPath)
        
        if recordState == .edit || recordState == .editAndUserInteractionDisabled {
            
            for record in editableRecords {
                
                if field.displayLabel == record.0
                    || field.apiName == record.0
                    || field.fieldLabel == record.0 {
                    
                    var shouldEnableUserInteracion = true
                    
                    if recordState == .editAndUserInteractionDisabled {
                        shouldEnableUserInteracion = false
                    }
                    
                    if field.dataType == "lookup" {
                        
                        if let lookupData = record.1 as? [String] {
                            recordsToBeSaved[indexPath.row] = (true, ["id", lookupData[0]])
                        }
                    }
                    recordsToBeSaved[indexPath.row] = (true, record.1)
                    cell.setRecordData(for: record.1, isEditable: shouldEnableUserInteracion)
                    break
                }
            }
        }
        cell.backgroundColor = .systemGray6
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = cell as! FormTableViewCell
        
        
        if let cellRecord = recordsToBeSaved[indexPath.row]?.1 {
            
            var isEditable = true
            if recordState == .editAndUserInteractionDisabled {
                isEditable = false
            }
            print(cellRecord, indexPath.row)
            
            cell.setRecordData(for: cellRecord, isEditable: isEditable)
//            print(recordsToBeSaved)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // If it is text area it should be bigger and it is scrollable so constant height
        if textAreaIndexes.contains(indexPath) {
            
            return 65
        } else {
            return UITableView.automaticDimension
        }
    }
}

extension FormTableViewController {
    
    @objc private func tapGesture(sender gestureRecognizer: UITapGestureRecognizer) {
        
        let cell = gestureRecognizer.view as! FormTableViewCell
        let location = gestureRecognizer.location(in: cell)
        
        if #available(iOS 9.0, *) {
            
            var canPresentLookup = false
            
            if UIView.userInterfaceLayoutDirection(
                for: view.semanticContentAttribute) == .rightToLeft {
                
                if location.x < cell.frame.width / 2 {
                    
                    canPresentLookup = true
                }
            } else {
                
                if location.x > cell.frame.width / 2 {
                    
                    canPresentLookup = true
                }
            }
            
            if canPresentLookup {
                if let cell = cell as? LookupTableViewCell {
                    
                    let moduleName = cell.lookupApiName
                    let lookupTableVC = RecordsTableViewController(module: moduleName!, isLookup: true)
                    lookupTableVC.delegate = cell.self
                    navigationController?.pushViewController(lookupTableVC, animated: true)
                } else if let cell = cell as? DateTableViewCell {
                    
                    let myPickerVC = PickerViewController()
                    
                    myPickerVC.showView(viewType: .dateView)
                    myPickerVC.modalPresentationStyle = .pageSheet
                    myPickerVC.delegate  = cell.self
                    
                    if let sheet = myPickerVC.sheetPresentationController {
                        sheet.prefersGrabberVisible = true
                        sheet.detents = [.medium(), .large()]
                        sheet.prefersEdgeAttachedInCompactHeight = true
                    }
                    
                    present(myPickerVC, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @objc private func pickListTapGesuture(sender gestureRecognizer: LookupTapGestureRecognizer) {
        
        let cell = gestureRecognizer.view as! PickListTableViewCell
        let location = gestureRecognizer.location(in: cell)
        
        let field = fields[gestureRecognizer.row!]
        let pickList = field.pickListValues
        let pickListName = field.fieldLabel
        let dataType = field.dataType
        
        if #available(iOS 9.0, *) {
            
            var canPresent = false
            
            if UIView.userInterfaceLayoutDirection(
                for: view.semanticContentAttribute) == .rightToLeft {
                
                // The view is shown in right-to-left mode right now.
                if location.x < cell.frame.width / 2 {
                    canPresent = true
                }
            } else {
                
                if location.x > cell.frame.width / 2 {
                    canPresent = true
                }
            }
            
            if canPresent {
                
                let lookupTableVC = MultiSelectTableViewController(pickListName: pickListName, pickListValues: pickList, isMultiSelect: dataType == "picklist" ? false : true)
                lookupTableVC.delegate = cell.self
                
                navigationController?.pushViewController(lookupTableVC, animated: true)
            }
        }
        //Should also handle lower ios versions
    }
}

extension FormTableViewController {
    
    // to make the form for edit view and fill up the fields
    func setUpCellsForEditing(recordid: String?, recordData: [(String, Any)],
                              recordState: RecordState = .edit) -> Void {
        
        self.recordState = recordState
        self.editableRecords = recordData
        self.editingRecordId = recordid
        self.tableView.reloadData()
    }
}

extension FormTableViewController: FormCellDelegate {
    
    func textFieldData(data: Any?, isValid: Bool, index: Int) {
        
        recordsToBeSaved[index] = (isValid, data)
    }
}

