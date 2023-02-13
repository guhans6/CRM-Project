//
//  ModuleTableViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import UIKit

class ModuleTableViewController: UITableViewController {
    
    private let modulePresenter = ModulesPresenter()
    private var modules = [Module]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Modules"
        view.backgroundColor = .systemBackground
        configureModuleTableView()
        getModules()
    }
    
    private func configureModuleTableView() {
        tableView.register(ModuleTableViewCell.self, forCellReuseIdentifier: ModuleTableViewCell.moduleTableViewCellIdentifier)

    }
    
    private func getModules() {
        modulePresenter.getModules { modules in
            self.modules = modules
            self.tableView.reloadData()
        }
    }
    
}

extension ModuleTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ModuleTableViewCell.moduleTableViewCellIdentifier) as! ModuleTableViewCell
        let module = modules[indexPath.row]
        cell.setUpModule(moduleName: module.moduleName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let module = modules[indexPath.row]
        let recordsTableVC = RecordsTableViewController(module: module.apiName)
        let _ = UINavigationController(rootViewController: recordsTableVC)
        navigationController?.pushViewController(recordsTableVC, animated: true)
    }
}
