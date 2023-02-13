//
//  ViewController.swift
//  FormPractice
//
//  Created by guhan-pt6208 on 06/02/23.
//

import UIKit

class FormTableViewController: UIViewController {
    
    private let tableView = UITableView()
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
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        registerTableViewCells()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func registerTableViewCells() {
        
        tableView.register(EmailTableViewCell.self, forCellReuseIdentifier: EmailTableViewCell.emailCellIdentifier)
        tableView.register(StringTableViewCell.self, forCellReuseIdentifier: StringTableViewCell.stringCellIdentifier)
        tableView.register(IntegerTableViewCell.self, forCellReuseIdentifier: IntegerTableViewCell.integerCellIdentifier)
        tableView.register(DoubleTableViewCell.self, forCellReuseIdentifier: DoubleTableViewCell.doubleCellIdentifier)
        tableView.register(BooleanTableViewCell.self, forCellReuseIdentifier: BooleanTableViewCell.booleanCellIdentifier)
        
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
            
            if field.fieldName == "Email" {
        
                cell = tableView.cellForRow(at: indexPath) as! EmailTableViewCell        
            } else {
                
                switch field.fieldType {
                case "String":
                    cell = tableView.cellForRow(at: indexPath) as! StringTableViewCell
                    
                case "integer":
                    cell = tableView.cellForRow(at: indexPath) as! IntegerTableViewCell
                    
                case "double":
                    cell = tableView.cellForRow(at: indexPath) as! DoubleTableViewCell
                    
                default:
                    cell = tableView.cellForRow(at: indexPath) as! StringTableViewCell
                }
                
            }
            let rfield = cell!.getField()
            print(rfield)
            if rfield.1 != nil {
                data[fields[row].fieldApiName] = rfield.1
            }
        }
        formPresenter.saveRecord(module: module, record: data)
        navigationController?.popViewController(animated: true)
    }
}

extension FormTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let field = fields[indexPath.row]
        var cell: FormTableViewCell? = nil
        
        if field.fieldName == "Email" {
            
            cell = tableView.dequeueReusableCell(withIdentifier: EmailTableViewCell.emailCellIdentifier) as! EmailTableViewCell
            
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
