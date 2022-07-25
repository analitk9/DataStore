//
//  FirebaseService.swift
//  Navigation
//
//  Created by Denis Evdokimov on 7/21/22.
//

import Foundation
import FirebaseAuth

class FirebaseService: LoginServiceProtocol {
    private func signOut(){
         let firebaseAuth = Auth.auth()
         do {
             try firebaseAuth.signOut()
         } catch let signOutError as NSError {
             print("Error signing out: %@", signOutError)
         }
     }
    
    func loginUserService(login: String?, password: String?, completion: @escaping Handler) {
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
    
    func createUserService(login: String?, password: String?, completion: @escaping Handler) {
        Auth.auth().createUser(withEmail: login ?? "", password: password ?? "") { authDataResult, error in
            if error == nil {
                completion(.success(String(describing: authDataResult?.user.email)))
                
            } else {
                    completion(.failure(.fbError(error.debugDescription)))
            }
        }
    }
    
    func autoLoginservice(completion: @escaping Handler) {
        completion(.success("test autologin"))
    }
    
    
}
