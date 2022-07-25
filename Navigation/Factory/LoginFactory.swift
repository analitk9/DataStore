//
//  LoginFactory.swift
//  Navigation
//
//  Created by Denis Evdokimov on 12/28/21.
//

import Foundation

enum LoginServiceType {
    case firebase
    case realm
}
protocol LoginFactory{
    func createLogInspector(typeOfServise: LoginServiceType)-> LoginInspector
}

class MyLoginFactory: LoginFactory {
    let typeOfServise: LoginServiceType
    init (typeOfServise: LoginServiceType){
        self.typeOfServise = typeOfServise
    }
    func createLogInspector(typeOfServise: LoginServiceType) -> LoginInspector {
        LoginInspector(loginservice: RealmService())
      //  LoginInspector( loginservice: typeOfServise)
    }
}
