//
//  User.swift
//  Navigation
//
//  Created by Denis Evdokimov on 12/26/21.
//

import Foundation
protocol UserService {
    func returnUser(for name: String) throws -> User
}

class User {
    var name: String
    var status: String?
    var avatar: String?
   
    init(name: String) {
        self.name = name
    }
}
