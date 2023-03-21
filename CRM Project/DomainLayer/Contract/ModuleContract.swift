//
//  ModuleContract.swift
//  CRM C
//
//  Created by guhan-pt6208 on 21/03/23.
//

import Foundation

protocol ModulesContract {
    
    func getModules(completion: @escaping ([Module]) -> Void) -> Void
}
