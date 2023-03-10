//
//  ModuleTableViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import UIKit

class ModulesTableViewController: UITableViewController {
    
    private var modulesController = ModulesController()
    private var recordsViewController: RecordsTableViewController?
    private var modules = [Module]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.showLoadingIndicator()
        configureModuleTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        getModules()
    }
    
    private func configureModuleTableView() {
        
        title = "Modules"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        tableView.separatorColor = .tableViewSeperator
        
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.identifier)

    }
    
    private func getModules() {
        
        modulesController.getModules { [weak self] modules in
            self?.modules = modules
            self?.tableView.reloadData()
            
            if modules.count == 0 {
                
                self?.tableView.hideLoadingIndicator()
                self?.tableView.setEmptyView(title: "No Modules Present", message: "")
            } else {
                
                self?.tableView.restore()
            }
            
        }
    }
    
}

extension ModulesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if modules.count > 0 {
            tableView.hideLoadingIndicator()
        }
        return modules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier) as! LabelTableViewCell
        let module = modules[indexPath.row]
        cell.configureCellWith(text: module.modulePluralName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let module = modules[indexPath.row]
        recordsViewController = RecordsTableViewController(module: module, isLookUp: false)
        let _ = UINavigationController(rootViewController: recordsViewController!)
        navigationController?.pushViewController(recordsViewController!, animated: true)
    }
}
