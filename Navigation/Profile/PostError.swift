//
//  PostError.swift
//  Navigation
//
//  Created by Denis Evdokimov on 2/14/22.
//

import Foundation

enum PostError: Error {
    case ErrorEmptyDate
}

extension PostError {
    var errorDescription: String {
        switch self {
        case .ErrorEmptyDate: return "Нет данных для постов"
        }
    }
}
