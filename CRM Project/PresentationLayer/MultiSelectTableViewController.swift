//
//  MultiSelectTableViewController.swift
//  CRM C
//
//  Created by guhan-pt6208 on 21/02/23.
//

import UIKit

class MultiSelectTableViewController: UITableViewController {
    
    private let pickListName: String
    private var pickListValues = [PickListValue]()
    private var isMultiSelect: Bool
    private var selectedItemsIndex: [Int] = []
    private var selectedItems: [String] = []
    weak var delegate: PickListDelegate?
    
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
            delegate?.getPickListValues(isMultiSelect: isMultiSelect, pickListValue: selectedItems)
            navigationController?.popViewController(animated: true)
            print(" No rows are selected")
            return
        }
        
        // Iterate over the selected rows and perform some action
        
        for indexPath in indexPaths {
            let pickListValue = pickListValues[indexPath.row]
            if !selectedItems.contains(pickListValue.displayValue) {
                selectedItems.append(pickListValue.displayValue)
            }
        }
        
        delegate?.getPickListValues(isMultiSelect: isMultiSelect, pickListValue: selectedItems)
        navigationController?.popViewController(animated: true)
    }
    
    func getPickListValues() -> [String] {

        return selectedItems
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pickListValues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordsTableViewCell.recordCellIdentifier,
                                                 for: indexPath) as! RecordsTableViewCell
        cell.removeImageView()
        let pickListValue = pickListValues[indexPath.row]
        cell.configureRecordCell(recordName: pickListValue.displayValue,
                                 secondaryData: "", recordImage: nil)
        
        cell.tintColor = .normalText
        
        // MARK: CUSTOM BGC FOR TAPPED CELL
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .tableSelect
        cell.selectedBackgroundView = selectedBackgroundView
        
        if selectedItemsIndex.contains(indexPath.row) == true {

            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            cell.accessoryType = .checkmark
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pickListValue = pickListValues[indexPath.row]
        if !isMultiSelect {
            
            delegate?.getPickListValues(isMultiSelect: isMultiSelect, pickListValue: [pickListValue.displayValue])
            navigationController?.popViewController(animated: true)
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let row = indexPath.row
        
        if selectedItemsIndex.contains(row) == false {

            selectedItems.append(pickListValue.displayValue)
            selectedItemsIndex.append(row)
            cell?.accessoryType = .checkmark
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if let index = selectedItemsIndex.firstIndex(of: indexPath.row) {
            selectedItemsIndex.remove(at: index)
//            selectedItems.remove(at: index)
            cell?.accessoryType = .none
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}

extension MultiSelectTableViewController {
    
    func setSelectedItems(_ items: [Int]) {
        
        selectedItemsIndex = items

    }
}
