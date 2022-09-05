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
        guard let login = login else {
            throw LoginError.emptyLogin
           
        }
        guard let password = password else {
            throw LoginError.emptyPassword
           
        }

        if  login.count == 0 {
            throw LoginError.emptyLogin
        }
        if password.count == 0 {
            throw LoginError.emptyPassword
        }

       
    }
}
