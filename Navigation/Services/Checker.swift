//
//  Checker.swift
//  Navigation
//
//  Created by Denis Evdokimov on 12/28/21.
//

import Foundation
class Checker {
    static let shared = Checker()
    private init(){}
    private let login = "1"
    private let password = "1"
    
    func verify(login: String, password: String) throws ->Bool  {
        if login.isEmpty {
            throw LoginError.emptyLogin
        }
        if password.isEmpty {
            throw LoginError.emptyPassword
        }
        if self.login == login && self.password == password {
            return true
        }
        if self.login != login {
            throw LoginError.wrongLogin
        }
        if self.password != password {
            throw LoginError.wrongPassword
        }
        return false
    }
}
