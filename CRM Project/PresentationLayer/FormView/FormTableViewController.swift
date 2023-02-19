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
        registerTableViewCells()
    }
    
    private func registerTableViewCells() {
        
        tableView.register(EmailTableViewCell.self, forCellReuseIdentifier: EmailTableViewCell.emailCellIdentifier)
        tableView.register(StringTableViewCell.self, forCellReuseIdentifier: StringTableViewCell.stringCellIdentifier)
        tableView.register(IntegerTableViewCell.self, forCellReuseIdentifier: IntegerTableViewCell.integerCellIdentifier)
        tableView.register(DoubleTableViewCell.self, forCellReuseIdentifier: DoubleTableViewCell.doubleCellIdentifier)
        tableView.register(BooleanTableViewCell.self, forCellReuseIdentifier: BooleanTableViewCell.booleanCellIdentifier)
        tableView.register(LookupTableViewCell.self, forCellReuseIdentifier: LookupTableViewCell.lookupCellIdentifier)
    }
    
    private func getFields() {
        formPresenter.getFieldsfor(module: module) { data in
            self.fields = data
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
            if field.lookUpApiName != nil {
                
                cell = tableView.cellForRow(at: indexPath) as! LookupTableViewCell
            } else {
                
                switch field.fieldType {
                case "String":
                    cell = tableView.cellForRow(at: indexPath) as! StringTableViewCell
                    
                case "integer":
                    cell = tableView.cellForRow(at: indexPath) as! IntegerTableViewCell
                    
                case "double":
                    cell = tableView.cellForRow(at: indexPath) as! DoubleTableViewCell
                case "boolean":
                    cell = tableView.cellForRow(at: indexPath) as! BooleanTableViewCell
                default:
                    cell = tableView.cellForRow(at: indexPath) as? FormTableViewCell
                }
                
            }
            let cellField = cell!.getFieldData(for: field.fieldType)
            print(cellField)
            if cellField.1 != nil {
                data[fields[row].fieldApiName] = cellField.1
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
        
        if field.fieldName == "Email" {
            
            cell = tableView.dequeueReusableCell(withIdentifier: EmailTableViewCell.emailCellIdentifier) as! EmailTableViewCell
            

        } else if field.lookUpApiName != nil {
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
            
            cell = tableView.dequeueReusableCell(withIdentifier: LookupTableViewCell.lookupCellIdentifier) as! LookupTableViewCell
           cell?.addGestureRecognizer(tapGesture)
           cell?.setLookupName(lookupApiName: field.lookUpApiName!)
            
        } else {
            
            switch field.fieldType {
                
            case "String":
                cell = tableView.dequeueReusableCell(withIdentifier: StringTableViewCell.stringCellIdentifier) as! StringTableViewCell
                
            case "integer":
                cell = tableView.dequeueReusableCell(withIdentifier: IntegerTableViewCell.integerCellIdentifier) as! IntegerTableViewCell
                
            case "double":
                cell = tableView.dequeueReusableCell(withIdentifier: DoubleTableViewCell.doubleCellIdentifier) as! DoubleTableViewCell
            case "boolean":
                cell = tableView.dequeueReusableCell(withIdentifier: BooleanTableViewCell.booleanCellIdentifier) as! BooleanTableViewCell
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: StringTableViewCell.stringCellIdentifier) as! StringTableViewCell
            }
        }
        
        cell?.setUpCellWith(fieldName: field.fieldName)
        
        if isRecordEditing  {
           editableRecords.forEach { key, value in
//                print(field.fieldName, key)
               if field.fieldName == key || field.fieldApiName == key {
                   cell?.setRecordData(for: value)
               }
           }
       }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc private func tapGesture(_ gestureRecognizer: UITapGestureRecognizer) {

        let cell = gestureRecognizer.view as! LookupTableViewCell
        let location = gestureRecognizer.location(in: cell)
        let moduleName = cell.lookupApiName

        if location.x > cell.frame.width / 2 {

            let lookupTableVC = LookupTableViewController(module: moduleName!)
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

