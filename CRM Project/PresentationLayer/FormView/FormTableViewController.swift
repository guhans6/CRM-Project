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
    private var module: String
    
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
        formPresenter.getLayout(module: module) { data in
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
        formPresenter.saveRecord(module: module, records: data)
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
            
            cell = tableView.dequeueReusableCell(withIdentifier: LookupTableViewCell.lookupCellIdentifier) as! LookupTableViewCell
            cell?.setLookupName(lookupApiName: field.lookUpApiName!)
        } else {
            
            switch field.fieldType {
                
            case "String":
                cell = tableView.dequeueReusableCell(withIdentifier: StringTableViewCell.stringCellIdentifier) as! StringTableViewCell
                
            case "integer":
                cell = tableView.dequeueReusableCell(withIdentifier: IntegerTableViewCell.integerCellIdentifier) as! IntegerTableViewCell
                
            case "double":
                cell = tableView.dequeueReusableCell(withIdentifier: DoubleTableViewCell.doubleCellIdentifier) as! DoubleTableViewCell
                
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: StringTableViewCell.stringCellIdentifier) as! StringTableViewCell
            }
        }
        cell?.setUpCellWith(fieldName: field.fieldName)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
