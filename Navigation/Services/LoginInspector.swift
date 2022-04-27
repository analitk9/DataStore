//
//  LoginInspector.swift
//  Navigation
//
//  Created by Denis Evdokimov on 12/28/21.
//

import Foundation
import Firebase

class LoginInspector: LoginViewCheckerDelegate {

    
    func signOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    
    func check(login: String?, password: String?)throws {
        try Checker.shared.verify(login: login, password: password) // проверка на пустые значения
    }
    
    func createUser(login: String?, password: String?, completion: @escaping(AuthDataResult?, Error?)-> Void)  {
      
        Auth.auth().createUser(withEmail: login ?? "", password: password ?? "", completion: completion)
    }
    
    func loginUser(login: String?, password: String?, completion: @escaping(AuthDataResult?, Error?)-> Void)  {
        guard  Auth.auth().currentUser == nil else {
            Auth.auth().signIn(withEmail: login ?? "", password: password ?? "", completion: completion)
            return // не залогинены
        }
        signOut()
        
        Auth.auth().signIn(withEmail: login ?? "", password: password ?? "", completion: completion)
        
    }
    
}
