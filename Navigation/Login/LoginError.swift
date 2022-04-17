//
//  LoginError.swift
//  Navigation
//
//  Created by Denis Evdokimov on 2/9/22.
//

enum LoginError: Error {
    case wrongLogin
    case wrongPassword
    case emptyLogin
    case emptyPassword
    case correct
}

extension LoginError {
    var errorDescription: String {
        switch self {
        case .wrongLogin: return "Не верно указан логин"
        case .wrongPassword: return "Не верно указан пароль"
        case .emptyLogin: return "Пустое поля логина"
        case .emptyPassword: return "Пустое поле пароля"
        case .correct: return "Верно"
        }
    }
}
