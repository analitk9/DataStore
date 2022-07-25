//
//  RealmService.swift
//  Navigation
//
//  Created by Denis Evdokimov on 7/21/22.
//

import Foundation
import  RealmSwift
class RealmService: LoginServiceProtocol {
    
    func loginUserService(login: String?, password: String?, completion: @escaping Handler) {
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
    func createUserService(login: String?, password: String?, completion: @escaping Handler) {
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
    
    func autoLoginservice(completion: @escaping Handler) {
        let realm = try! Realm()
        let user = realm.objects(RealmAuthModel.self)
        if user.count != 0 {
            completion(.success(user.first!.login))
        }else {
            completion(.failure(.wrongAutoLogin))
        }
    }
    
    
}
