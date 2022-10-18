//
//  PhotoViewCoordinator.swift
//  Navigation
//
//  Created by Denis Evdokimov on 1/24/22.
//

import UIKit
final class PhotoViewCoordinator: Coordinator {
    
    private weak var navigationController: UINavigationController?
    private let viewControllerFactory: ViewControllerFactoryProtocol
    init(navigationController: UINavigationController, viewControllerFActory: ViewControllerFactoryProtocol ){
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFActory
        
    }
    
    func start() {
        let photoVC = PhotosViewController()
        navigationController?.pushViewController(photoVC, animated: true)
    }
    
    
}
