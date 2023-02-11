//
//  RecordsTableViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import UIKit


class RecordsTableViewController: UIViewController {
    
    private let recordsTableView = UITableView()
    private let recordsPresenter = RecordsPresenter()
    private var module: String
    private var records = [Record]()
    
    init(module: String) {
        self.module = module
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = module
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewRecordButtonTapped))
        configureRecordsTableView()
        getRecords()
    }
    
    private func configureRecordsTableView() {
        view.addSubview(recordsTableView)
        
        recordsTableView.translatesAutoresizingMaskIntoConstraints = false
        recordsTableView.delegate = self
        recordsTableView.dataSource = self
        recordsTableView.register(RecordsTableViewCell.self, forCellReuseIdentifier: RecordsTableViewCell.recordCellIdentifier)
        
        NSLayoutConstraint.activate([
            recordsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recordsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            recordsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            recordsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func getRecords() {
        recordsPresenter.displayRecords(for: module) { records in
            self.records = records
            self.recordsTableView.reloadData()
        }
    }
    
    @objc private func addNewRecordButtonTapped() {
        let formViewController = FormTableViewController(module: module)
        navigationController?.pushViewController(formViewController, animated: true)
    }
}

extension RecordsTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordsTableViewCell.recordCellIdentifier) as! RecordsTableViewCell
        let record = records[indexPath.row]
        cell.configureRecordCell(recordName: record.recordName, secondaryData: record.secondaryRecordData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
