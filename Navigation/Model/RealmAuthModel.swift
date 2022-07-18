//
//  RealmAuthModel.swift
//  Navigation
//
//  Created by Denis Evdokimov on 5/12/22.
//

import Foundation
import RealmSwift

class RealmAuthModel: Object {
    @Persisted var login: String = ""
    @Persisted var password: String = ""
}
