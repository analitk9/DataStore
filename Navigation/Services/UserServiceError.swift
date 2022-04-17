//
//  UserServiceError.swift
//  Navigation
//
//  Created by Denis Evdokimov on 2/14/22.
//

import Foundation

enum UserServiceError: Error {
    case userNotFound
}

extension UserServiceError{
    var errorDescription: String {
        switch self {
        case .userNotFound: return "Пользователь не найден"
        }
    }
}
