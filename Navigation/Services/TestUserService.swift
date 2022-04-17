//
//  TestUserService.swift
//  Navigation
//
//  Created by Denis Evdokimov on 12/26/21.
//

import Foundation
class TestUserService{
    let user: User
    init(){
        user = User(name: "Тест")
    }
}

extension TestUserService: UserService {
    func returnUser(for name: String)throws -> User {
        user
    }
}
