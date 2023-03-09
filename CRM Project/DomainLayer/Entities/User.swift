//
//  User.swift
//  CRM C
//
//  Created by guhan-pt6208 on 26/02/23.
//

import Foundation

struct User {
    
    let id: String
    let fullName: String
    let email: String
    
    init(id: String, fullName: String, email: String) {
        self.id = id
        self.fullName = fullName
        self.email = email
    }
}
