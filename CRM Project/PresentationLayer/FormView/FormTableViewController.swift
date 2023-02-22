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
    private lazy var editableRecords = [(String, String)]()
    private var module: String
    private var isRecordEditing = false
    private var editingRecordId: String?
    private lazy var textAreaIndexes = [IndexPath]()
    
    init(module: String) {
        self.module = module
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        
        configureTableView()
        configureNavigationBar()
        getFields()
    }
    
    private func configureNavigationBar() {
        
        let saveButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(doneButtonClicked))
        
        navigationItem.rightBarButtonItems = [saveButton]
        
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
    }
    
    private func getFields() {
        formPresenter.getFieldsfor(module: module) { fields in
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
            //d
            if field.lookup.apiName != nil {
                
                cell = tableView.cellForRow(at: indexPath) as! LookupTableViewCell
            } else {
                
                switch field.dataType {
                case "String":
                    cell = tableView.cellForRow(at: indexPath) as! StringTableViewCell
                    
                case "phone":
                    
                    fallthrough
                case "integer":
                    cell = tableView.cellForRow(at: indexPath) as! IntegerTableViewCell
                    
                case "double":
                    
                    cell = tableView.cellForRow(at: indexPath) as! DoubleTableViewCell
                case "boolean":
                    
                    cell = tableView.cellForRow(at: indexPath) as! BooleanTableViewCell
                case "picklist":
                    
                    fallthrough
                case "multiselectpicklist":
                    
                    cell = tableView.cellForRow(at: indexPath) as! PickListTableViewCell
                default:
                    
                    cell = tableView.cellForRow(at: indexPath) as? FormTableViewCell
                }
                
            }
            let cellField = cell!.getFieldData(for: field.dataType)
//            print(cellField)
            if cellField.1 != nil {
                data[fields[row].apiName] = cellField.1
            }
        }
        
        if isRecordEditing {

            formPresenter.updateRecord(module: module, records: data, recordId: editingRecordId)
        } else {
            formPresenter.saveRecord(module: module, records: data)
        }
//        formPresenter.saveRecord(module: module, records: data)
        navigationController?.popViewController(animated: true)
    }
}

extension FormTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let field = fields[indexPath.row]
        var cell: FormTableViewCell? = nil
//        print(field.lookUpApiName)
        
        switch field.dataType {
            
        case "lookup":
            
            cell = tableView.dequeueReusableCell(withIdentifier: LookupTableViewCell.lookupCellIdentifier) as! LookupTableViewCell
            cell?.setLookupName(lookupApiName: field.lookup.module!.apiName)
        case "email":
            
            cell = tableView.dequeueReusableCell(withIdentifier: EmailTableViewCell.emailCellIdentifier) as! EmailTableViewCell
        case "text":
            
            cell = tableView.dequeueReusableCell(withIdentifier: StringTableViewCell.stringCellIdentifier) as! StringTableViewCell
        case "textarea":
            
            cell = tableView.dequeueReusableCell(withIdentifier: TextAreaTableViewCell.textAreaCellIdentifier) as! TextAreaTableViewCell
            textAreaIndexes.append(indexPath)
        case "integer":
            fallthrough
        case "phone":
            
            cell = tableView.dequeueReusableCell(withIdentifier: IntegerTableViewCell.integerCellIdentifier) as! IntegerTableViewCell
        case "double":
            
            cell = tableView.dequeueReusableCell(withIdentifier: DoubleTableViewCell.doubleCellIdentifier) as! DoubleTableViewCell
        case "boolean":
            
            cell = tableView.dequeueReusableCell(withIdentifier: BooleanTableViewCell.booleanCellIdentifier) as! BooleanTableViewCell
            
        case "picklist":
            
            fallthrough
        case "multiselectpicklist":
            
            cell = tableView.dequeueReusableCell(withIdentifier: PickListTableViewCell.pickListCellIdentifier) as! PickListTableViewCell
        default:
            
            cell = tableView.dequeueReusableCell(withIdentifier: StringTableViewCell.stringCellIdentifier) as! StringTableViewCell
        }
        
        if field.dataType == "picklist" || field.dataType == "multiselectpicklist" {
            
            let pickListTapGesuture = LookupTapGestureRecognizer(target: self, action: #selector(pickListTapGesuture(sender:)))
            pickListTapGesuture.row = indexPath.row
            cell?.addGestureRecognizer(pickListTapGesuture)
            
        } else if field.dataType == "lookup" {
            
            let tapGesture = LookupTapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
            cell?.addGestureRecognizer(tapGesture)
        }
        
        cell?.setUpCellWith(fieldName: field.fieldLabel)
        
        if isRecordEditing  {
           editableRecords.forEach { key, value in

               if field.fieldLabel == key || field.apiName == key {
                   cell?.setRecordData(for: value)
//                   print(cell == nil ? "y" : "n")
               }
           }
       }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if textAreaIndexes.contains(indexPath) {

            return 65
        } else {
            return UITableView.automaticDimension
        }
//        UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc private func tapGesture(sender gestureRecognizer: UITapGestureRecognizer) {

        let cell = gestureRecognizer.view as! LookupTableViewCell
        let location = gestureRecognizer.location(in: cell)
        let moduleName = cell.lookupApiName
//        print(moduleName)
        if location.x > cell.frame.width / 2 {

            let lookupTableVC = LookupTableViewController(module: moduleName!)
            lookupTableVC.delegate = cell.self
            navigationController?.pushViewController(lookupTableVC, animated: true)
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

    func setUpCellsForEditing(recordid: String, recordData: [(String, String)]) -> Void {
        self.isRecordEditing = true
        self.editableRecords = recordData
        self.editingRecordId = recordid
        self.tableView.reloadData()
    }
}

