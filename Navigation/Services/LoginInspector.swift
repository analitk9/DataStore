//
//  LoginInspector.swift
//  Navigation
//
//  Created by Denis Evdokimov on 12/28/21.
//

import Foundation
import Firebase
import RealmSwift

enum LoginService {
    case firebase
    case realm
}

class LoginInspector: LoginViewCheckerDelegate {
    

    let typeOfServise: LoginService
    
    init (loginservice: LoginService) {
        typeOfServise = loginservice
    }

   private func check(login: String?, password: String?)throws {
        try Checker.shared.verify(login: login, password: password) // проверка на пустые значения
    }
    
    // MARK: - Interface
    
    func createUser(login: String?, password: String?, completion: @escaping Handler)  {
      
        switch typeOfServise {
        case .firebase:
            fbCreateUser(login: login, password: password, completion: completion)
        case .realm:
            rmCreateUser(login: login, password: password, completion: completion)
        }
    }
    
    func loginUser(login: String?, password: String?, completion: @escaping  Handler) {
        switch typeOfServise {
        case .firebase:
            fbLoginUser(login: login, password: password, completion: completion)
        case .realm:
            rmLoginUser(login: login, password: password, completion: completion)
        }
    }
    // MARK: -   Firebase
    
   private func signOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    private func fbLoginUser(login: String?, password: String?, completion: @escaping  Handler) {
        
        if Auth.auth().currentUser == nil {
            signOut()
        }
        Auth.auth().signIn(withEmail: login ?? "", password: password ?? ""){ authDataResult, error in
            if error == nil {
                completion(.success(String(describing: authDataResult?.user.email)))
                
            } else {
                completion(.failure(.fbError(error.debugDescription)))
            }
        }
    }
    
    private func fbCreateUser(login: String?, password: String?, completion: @escaping Handler){
        
        Auth.auth().createUser(withEmail: login ?? "", password: password ?? "") { authDataResult, error in
            if error == nil {
                completion(.success(String(describing: authDataResult?.user.email)))
                
            } else {
                    completion(.failure(.fbError(error.debugDescription)))
            }
        }
    }
    
    // MARK: - Realm
    
    private func rmCreateUser(login: String?, password: String?, completion: @escaping Handler){
        do {
            try check(login: login, password: password)
        }catch {
            completion(.failure(error as! LoginError))
        }
        
        do {
            let realm = try Realm()
            try realm.write {
                let user = RealmAuthModel()
                user.login = login!
                user.password = password!
                realm.add(user)
            }
            completion(.success(login!))
        }catch  let error {
            completion(.failure(.fbError(error.localizedDescription)))
        }
    }
    
    private func rmLoginUser(login: String?, password: String?, completion: @escaping Handler){
        do {
            try check(login: login, password: password)
        }catch {
            completion(.failure(error as! LoginError))
        }
        
        do {
            let realm = try Realm()
            let user = realm.objects(RealmAuthModel.self)
            let curUser =  user.contains(where: {$0.login == login && $0.password == password})
            if  curUser {
                completion(.success(login!))
            } else {
                completion(.failure(LoginError.loginError))
            }
        }catch let error {
            completion(.failure(.fbError(error.localizedDescription)))
        }
    
    }
    
    func autoLogin(completion: @escaping Handler){
        let realm = try! Realm()
        let user = realm.objects(RealmAuthModel.self)
        if user.count != 0 {
            completion(.success(user.first!.login))
        }else {
            completion(.failure(.wrongAutoLogin))
        }
    }
    
    
}
