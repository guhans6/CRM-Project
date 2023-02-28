//
//  ViewController.swift
//  FormPractice
//
//  Created by guhan-pt6208 on 06/02/23.
//

import UIKit

class FormTableViewController: UITableViewController {
    
    private let formPresenter = FormPresenter()
    private var fields = [Field]()
    private lazy var editableRecords = [(String, Any)]()
    private var module: Module?
    private var moduleName: String?
    private var isRecordEditing = false
    private var editingRecordId: String?
    private var moduleApiName: String!
    private lazy var textAreaIndexes = [IndexPath]()
    
    init(module: Module) {
        self.module = module
//        self.isRecordEditing = isRecordEditing
        super.init(nibName: nil, bundle: nil)
    }
    
    init(moduleApiName: String) {
        self.moduleName = moduleApiName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if let module {
            self.moduleApiName = module.apiName
        } else if let moduleName {
            self.moduleApiName = moduleName
        }
        
        configureTableView()
        configureNavigationBar()
        getFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        if isRecordEditing {
            
            title = "Edit ".appending(moduleApiName)
        } else {
            
            title = "Add ".appending(moduleApiName)
        }
    }
    
    private func configureNavigationBar() {
        
        let saveButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(doneButtonClicked))
        
        navigationItem.rightBarButtonItems = [saveButton]
        navigationItem.largeTitleDisplayMode = .always
//        navigationController?.navigationBar.prefersLargeTitles = trues
    }

    private func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
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
        
        formPresenter.getFieldsfor(module: moduleApiName) { fields in
            self.fields = fields
            self.tableView.reloadData()
        }
    }
    
    @objc private func doneButtonClicked() {
        // SAVE DATA
        var data = [String: Any]()
        let rows = tableView.numberOfRows(inSection: 0)
        for row in 0..<rows {
            
            let indexPath = IndexPath(row: row, section: 0)
            let field = fields[row]
            let cell: FormTableViewCell?
//            print(field.apiName)
            if field.lookup.apiName != nil {
                
                cell = tableView.cellForRow(at: indexPath) as! LookupTableViewCell
            } else {
                
                switch field.dataType {
                case "String":
                    cell = tableView.cellForRow(at: indexPath) as! StringTableViewCell
                    
                case "phone", "integer":
                    
                    cell = tableView.cellForRow(at: indexPath) as! IntegerTableViewCell
                case "double":
                    
                    cell = tableView.cellForRow(at: indexPath) as! DoubleTableViewCell
                case "boolean":
                    
                    cell = tableView.cellForRow(at: indexPath) as! BooleanTableViewCell
                case "picklist", "multiselectpicklist":
                    
                    cell = tableView.cellForRow(at: indexPath) as! PickListTableViewCell
                default:
                    
                    cell = tableView.cellForRow(at: indexPath) as? FormTableViewCell
                }
                
            }
            let cellField = cell!.getFieldData(for: field.dataType)
            if cellField.1 != nil {
                
                if isReadyToSaveOrUpdate(field: field, recordData: cellField.1) {
                    
                    return
                }
                    
                
                data[field.apiName] = cellField.1
            }
        }
//        data.forEach { key, value in
//            print(key, value)
//        }
        if editingRecordId != nil {

            formPresenter.updateRecord(module: moduleApiName, records: data, recordId: editingRecordId)
        } else {
            formPresenter.saveRecord(module: moduleApiName, records: data)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func isReadyToSaveOrUpdate(field: Field, recordData: Any?) -> Bool {
        
        if (field.apiName == "Email" || field.isSystemMandatory) && recordData as! String == "" {
            print("Its Working")
            tableView.beginUpdates()
            tableView.endUpdates()
            return false
        }
        return true
    }
    
}

extension FormTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fields.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let field = fields[indexPath.row]
        var cell: FormTableViewCell!
        let tapGesture = LookupTapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
//        print(field.lookUpApiName)
//        print(field.dataType)
        
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
            print(field.fieldLabel, field.dataType)
            cell = tableView.dequeueReusableCell(withIdentifier: IntegerTableViewCell.integerCellIdentifier) as! IntegerTableViewCell
        case "double", "currency":
            print(field.fieldLabel, field.dataType)
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
        
        cell?.setUpCellWith(fieldName: field.fieldLabel, isMandatory: field.isSystemMandatory)
        
        if isRecordEditing  {
            for record in editableRecords {


                if field.fieldLabel == record.0 || field.apiName == record.0 {
                    
                    cell?.setRecordData(for: record.1)
                    break
                }
            }
       }
        
        return cell
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
        
//        print(moduleName)
        if location.x > cell.frame.width / 2 {

            if let cell = cell as? LookupTableViewCell {
                
                let moduleName = cell.lookupApiName
                let lookupTableVC = RecordsTableViewController(module: moduleName!, isLookup: true)
                lookupTableVC.delegate = cell.self
                navigationController?.pushViewController(lookupTableVC, animated: true)
                
            } else if let cell = cell as? DateTableViewCell {
                
                let myPickerVC = MyPickerViewController()
                
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
    
    @objc private func pickListTapGesuture(sender gestureRecognizer: LookupTapGestureRecognizer) {
        
        let cell = gestureRecognizer.view as! PickListTableViewCell
        let location = gestureRecognizer.location(in: cell)
        let field = fields[gestureRecognizer.row!]
        let pickList = field.pickListValues
        let pickListName = field.fieldLabel
        let dataType = field.dataType

        if location.x > cell.frame.width / 2 {
            
            let lookupTableVC = MultiSelectTableViewController(pickListName: pickListName, pickListValues: pickList, isMultiSelect: dataType == "picklist" ? false : true)
            lookupTableVC.delegate = cell.self
            navigationController?.pushViewController(lookupTableVC, animated: true)
        }
    }
}


extension FormTableViewController: FormViewContract {
    
    func displayFormWith(fields: [Field]) {
        self.fields = fields
        self.tableView.reloadData()
    }
}

extension FormTableViewController {

    // to make the form for edit view and fill up the fields

    func setUpCellsForEditing(recordid: String?, recordData: [(String, Any)]) -> Void {
        
        self.isRecordEditing = true
        self.editableRecords = recordData
        self.editingRecordId = recordid
        self.tableView.reloadData()
    }
}
