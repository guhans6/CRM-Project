//
//  ModuleTableViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 10/02/23.
//

import UIKit

class ModulesTableViewController: UITableViewController {
    
    var modulePresenter: ModulesPresenterContract = ModulesPresenter()
    private var modules = [Module]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        tableView.register(ModuleTableViewCell.self, forCellReuseIdentifier: ModuleTableViewCell.moduleTableViewCellIdentifier)

    }
    
    private func getModules() {
        tableView.showLoadingIndicator()
        modulePresenter.getModules { [weak self] modules in
            self?.modules = modules
            
            // These below is to test if the activity indicator is working
//            sleep(4)
//            self?.modules = [Module]()
            
            if self?.modules.count ?? 0 > 0 {
                
                self?.tableView.reloadData()
            } else {
                self?.tableView.hideLoadingIndicator()
                self?.tableView.setEmptyView(title: "No Modules Present", message: "")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ModuleTableViewCell.moduleTableViewCellIdentifier) as! ModuleTableViewCell
        let module = modules[indexPath.row]
        cell.setUpModule(moduleName: module.modulePluralName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let module = modules[indexPath.row]
        let recordsTableVC = RecordsTableViewController(module: module, isLookUp: false)
        let _ = UINavigationController(rootViewController: recordsTableVC)
        navigationController?.pushViewController(recordsTableVC, animated: true)
    }
}

extension ModulesTableViewController: ModuleViewContract {
    
    func showModules(modules: [Module]) {
        self.modules = modules
        self.tableView.reloadData()
    }
}
