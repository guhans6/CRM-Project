//
//  MultiSelectTableViewController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 21/02/23.
//

import UIKit

class MultiSelectTableViewController: UITableViewController {
    
    private let pickListName: String
    var pickListValues = [PickListValue]()
    var delegate: PickListDelegate?
    var isMultiSelect: Bool
    var selectedItems: [Int] = []
    
    init(pickListName: String, pickListValues: [PickListValue], isMultiSelect: Bool = false) {
        self.pickListValues = pickListValues
        self.isMultiSelect = isMultiSelect
        self.pickListName = pickListName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    private func configureTableView() {
        
        title = pickListName
        tableView.allowsMultipleSelection = true
        
        tableView.register(RecordsTableViewCell.self, forCellReuseIdentifier: RecordsTableViewCell.recordCellIdentifier)
        
        if isMultiSelect {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didPressSaveButton))
        }
    }
    
    @objc private func didPressSaveButton() {
        
        guard let indexPaths = tableView.indexPathsForSelectedRows else {
            print(" No rows are selected")
            return
        }
        
        // Iterate over the selected rows and perform some action
        var values = [String]()
        for indexPath in indexPaths {
            let pickListValue = pickListValues[indexPath.row]
            values.append(pickListValue.displayValue)
        }
        
        delegate?.getPickListValues(isMultiSelect: isMultiSelect, pickListValue: values)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pickListValues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordsTableViewCell.recordCellIdentifier,
                                                 for: indexPath) as! RecordsTableViewCell
        
        let pickListValue = pickListValues[indexPath.row]
        cell.configureRecordCell(recordName: pickListValue.displayValue, secondaryData: "")
        
        cell.tintColor = .normalText
        
        // MARK: CUSTOM BGC FOR TAPPED CELL
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .tableSelect
        cell.selectedBackgroundView = selectedBackgroundView

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isMultiSelect {
            
            let pickListValue = pickListValues[indexPath.row]
            delegate?.getPickListValues(isMultiSelect: isMultiSelect, pickListValue: [pickListValue.displayValue])
            navigationController?.popViewController(animated: true)
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let row = indexPath.row
        
        if selectedItems.contains(row) == false {

            selectedItems.append(row)
            cell?.accessoryType = .checkmark
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if let index = selectedItems.firstIndex(of: indexPath.row) {
            selectedItems.remove(at: index)
            cell?.accessoryType = .none
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}
