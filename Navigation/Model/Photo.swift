//
//  Photo.swift
//  Navigation
//
//  Created by Denis Evdokimov on 11/15/21.
//

import Foundation

struct Photo{
    let name: String
}

class Photos {
    private var photos: [Photo] = [Photo]()
    
     func createMockPhotos()-> [Photo]{
        Array(1...20).map{ Photo(name: $0.description) }
    }
}
