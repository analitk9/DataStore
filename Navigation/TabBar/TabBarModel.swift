//
//  TabBarModel.swift
//  Navigation
//
//  Created by Denis Evdokimov on 9/5/22.
//

import Foundation
import UIKit

enum TabBarModel: CaseIterable {
    case main
    case favorite
//    case media
    case mapLocation
    
    
    
    var title: String {
        switch self {
        case .main:
            return "Profile".localize()
        case .favorite:
            return "Favourites".localize()
        case .mapLocation:
            return "Location".localize()
//        case .media:
//            return "Media".localize()
        }
    }
    
    var image: UIImage? {
        switch self {
        case .main:
            return UIImage(systemName: "person")
        case .favorite:
            return UIImage(systemName: "bookmark")
//        case .media:
//            return UIImage(systemName: "music.note.tv")
        case .mapLocation:
            return UIImage(systemName: "globe.europe.africa")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .main:
            return UIImage(systemName: "person.fill")
        case .favorite:
            return UIImage(systemName: "bookmark.fill")
//        case .media:
//            return UIImage(systemName: "music.note.tv.fill")
        case .mapLocation:
            return UIImage(systemName: "globe.europe.africa.fill")
        }
    }
    
}
