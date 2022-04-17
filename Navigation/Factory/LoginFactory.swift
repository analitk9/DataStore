//
//  LoginFactory.swift
//  Navigation
//
//  Created by Denis Evdokimov on 12/28/21.
//

import Foundation
protocol LoginFactory{
    func createLogInspector()-> LoginInspector
}

class MyLoginFactory: LoginFactory {
    func createLogInspector() -> LoginInspector {
        LoginInspector()
    }
}
