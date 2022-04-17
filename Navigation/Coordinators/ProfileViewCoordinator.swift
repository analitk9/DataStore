//
//  ProfileViewCoordinator.swift
//  Navigation
//
//  Created by Denis Evdokimov on 1/24/22.
//

import UIKit
final class ProfileViewCoordinator: Coordinator {
    private var userService: UserService!
    private weak var navigationController: UINavigationController?
    private let viewControllerFactory: ViewControllerFactoryProtocol
    let name: String
    init(viewControllerFactory: ViewControllerFactoryProtocol, navigationController: UINavigationController, name: String){
        self.viewControllerFactory = viewControllerFactory
        self.navigationController = navigationController
        self.name = name
    }
    
    func start() {
        let postModel = Posts()
        let photoModel = Photos()
        let model = ProfileViewModel(postsService: postModel, photoService: photoModel)
        model.toPhotoVC = toPhotoVC
        #if DEBUG
                self.userService = TestUserService()
        #else
                self.userService = CurrentUserService()
        #endif
        let profileVC = viewControllerFactory.createController(type: .profileVC(model, userService, name)) as! ProfileViewController
      
        navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    func toPhotoVC(){
        guard let navigationController = navigationController else { return }
        let photoViewCoordinator = PhotoViewCoordinator(navigationController: navigationController, viewControllerFActory: viewControllerFactory)
        photoViewCoordinator.start()
    }
    
    
}
