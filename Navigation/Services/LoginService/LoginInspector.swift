//
//  LoginInspector.swift
//  Navigation
//
//  Created by Denis Evdokimov on 12/28/21.
//

import Foundation

protocol LoginServiceProtocol: AnyObject {
    typealias Handler = (Result<String, LoginError>)->Void
    func loginUserService(login: String?, password: String?, completion: @escaping Handler)
    func createUserService(login: String?, password: String?, completion: @escaping Handler)
    func autoLoginservice(completion: @escaping Handler)
   
}
class LoginInspector: LoginViewCheckerDelegate {
    
    var service: LoginServiceProtocol
    
    init (loginservice: LoginServiceProtocol) {
        service = loginservice
    }

   private func check(login: String?, password: String?)throws {
        try Checker.shared.verify(login: login, password: password) // проверка на пустые значения
    }
    
    // MARK: - Interface
    
    func createUser(login: String?, password: String?, completion: @escaping Handler)  {
        do {
            try check(login: login, password: password) //  проверка на пустые значения
        }catch {
            completion(.failure(error as! LoginError))
        }
        
        service.createUserService(login: login, password: password, completion: completion)

    }
    
    func loginUser(login: String?, password: String?, completion: @escaping  Handler) {
        do {
            try check(login: login, password: password) //  проверка на пустые значения
        }catch {
            completion(.failure(error as! LoginError))
        }
        
        service.loginUserService(login: login, password: password, completion: completion)
        
    }

   func autoLogin(completion: @escaping Handler){
      
       service.autoLoginservice(completion: completion)

   }
    
    
}




