//
//  PasswordCheckerModel.swift
//  Navigation
//
//  Created by Denis Evdokimov on 1/23/22.
//

import Foundation

class PasswordCheckerService{
    let password: String
    
    init(password: String){
        self.password = password
    }
    
    func check(word: String) {
        NotificationCenter.default.post(name: NSNotification.Name(NSNotification.checkPassword), object: word == password)
    }
}
extension NSNotification {
    static let checkPassword = "checkPassword"
}
