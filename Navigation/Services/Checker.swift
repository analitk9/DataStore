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
    
    func verify(login: String?, password: String?) throws  {
        if login == nil {
            throw LoginError.emptyLogin
        }
        if password == nil {
            throw LoginError.emptyPassword
        }

       
    }
}
