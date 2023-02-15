//
//  RecordsTableViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import UIKit


class RecordsTableViewController: UITableViewController {
    
    private let recordsPresenter = RecordsPresenter()
    private var module: String
    var records = [Record]()
    
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
    
    private func configureNavigationBar() {
        
        
    }
    
    private func configureRecordsTableView() {
        tableView.register(RecordsTableViewCell.self, forCellReuseIdentifier: RecordsTableViewCell.recordCellIdentifier)
    }
    
    private func getRecords() {
        recordsPresenter.displayRecords(for: module) { records in
            self.records = records
//            records.forEach { record in
//                print(record.recordId)
//            }
            self.tableView.reloadData()
        }
    }
    
    @objc private func addNewRecordButtonTapped() {
        let formViewController = FormTableViewController(module: module)
        navigationController?.pushViewController(formViewController, animated: true)
    }
    
    @objc private func editButtonClicked() {
        
    }
}

extension RecordsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordsTableViewCell.recordCellIdentifier) as! RecordsTableViewCell
        let record = records[indexPath.row]
        cell.configureRecordCell(recordName: record.recordName, secondaryData: record.secondaryRecordData)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let record = records[indexPath.row]
        
        let individualRecordVC = RecordInfoTableViewController(recordModule: module, recordId: record.recordId)
        let _ = UINavigationController(rootViewController: individualRecordVC)
        navigationController?.pushViewController(individualRecordVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeConfiguration = UIContextualAction(style: .destructive, title: "Delete") { action, view, complete in
            let record = self.records.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.recordsPresenter.deleteRecords(for: self.module, ids: [record.recordId])
            complete(true)
        }
        return UISwipeActionsConfiguration(actions: [swipeConfiguration])
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
