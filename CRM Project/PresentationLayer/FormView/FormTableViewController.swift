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

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(doneButtonClicked))
        configureTableView()
        getFields()
    }
    
    

    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FormTableViewCell.self, forCellReuseIdentifier: FormTableViewCell.cellIdentifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func getFields() {
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
            let cell = tableView.cellForRow(at: indexPath) as! FormTableViewCell
            let field = cell.getField()
            if field.1 != nil {
                data[fields[row].fieldApiName] = field.1
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
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.cellIdentifier) as! FormTableViewCell
        let field = fields[indexPath.row]
//        print(field)
        cell.setField(fieldName: field.fieldName, fieldType: field.fieldType)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}
