//
//  LoginFactory.swift
//  Navigation
//
//  Created by Denis Evdokimov on 12/28/21.
//

import Foundation
protocol LoginFactory{
    func createLogInspector(typeOfServise: LoginService)-> LoginInspector
}

class MyLoginFactory: LoginFactory {
    let typeOfServise: LoginService
    init (typeOfServise: LoginService){
        self.typeOfServise = typeOfServise
    }
    func createLogInspector(typeOfServise: LoginService) -> LoginInspector {
        LoginInspector( loginservice: typeOfServise)
    }
}
