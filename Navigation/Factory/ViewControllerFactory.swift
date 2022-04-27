//
//  ViewControllerFactory.swift
//  Navigation
//
//  Created by Denis Evdokimov on 1/26/22.
//

import UIKit


enum typeOfController {
    case loginVC(LoginViewModel)
    case feedVC(FeedViewModel)
    case infoVC
    case postVC
    case profileVC(ProfileViewModel, UserService,String)
    case photoVC
}
protocol ViewControllerFactoryProtocol {
    func createController(type: typeOfController)-> UIViewController
}

class ViewControllerFactory: ViewControllerFactoryProtocol{
    func createController(type: typeOfController) -> UIViewController {
        switch type {
        case let .profileVC(model, userService, name):
            return ProfileViewController(model: model, userService: userService, name: name)
            
        case let . loginVC(model):
            return LogInViewController(model: model)
            
        case .postVC:
            return PostViewController()
            
        case let .feedVC(model):
            return FeedViewController(model: model)
            
        case.infoVC:
            return InfoViewController()
            
        case .photoVC:
            return PhotosViewController()
        }
    }
    
    
}
