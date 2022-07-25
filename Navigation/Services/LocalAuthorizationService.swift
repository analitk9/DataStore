//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by Denis Evdokimov on 7/25/22.
//

import Foundation
import LocalAuthentication

enum AuthType: String {
    case faceid = "faceid"
    case touchid = "touchid"
    case none = ""
}

protocol LocalAuthorizationServiceProtocol{
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void)
    func BiometryType() -> AuthType
    func AuthenticationWithBiometrics(_ complition: @escaping (Result<String, LoginError>)-> Void )
}

class LocalAuthorizationService {
    let context: LAContext = {
        let context = LAContext()
        return context
    }()
    let policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
    var policyError: NSError?
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {
        let permission = context.canEvaluatePolicy(policy, error: &policyError)
       // DispatchQueue.main.async {
        if permission {
            authorizationFinished(permission)
        }else if let policyError = self.policyError {
            print(policyError.localizedDescription)
            authorizationFinished(false)
        }
      //  }
    }
    
    func BiometryType() -> AuthType {
        switch context.biometryType {
        case .faceID: return .faceid
        case .touchID: return .touchid
        case .none: return .none
        default: return .none
        }
    }
    
    func AuthenticationWithBiometrics(_ complition: @escaping (Result<String, LoginError>)-> Void ) {
        let reason = "Log in to your account"
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
            if success {
                DispatchQueue.main.async {
                    complition(.success("BIO LOGIN"))
                }
            } else {
                if error != nil {
                    DispatchQueue.main.async {
                        complition(.failure(.bioAuthError(error!.localizedDescription)))
                    }
                }
            }
        }
    }
}
