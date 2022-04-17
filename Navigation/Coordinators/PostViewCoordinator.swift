//
//  PostViewCoordinator.swift
//  Navigation
//
//  Created by Denis Evdokimov on 1/24/22.
//

import UIKit
final class PostViewCoordinator: Coordinator {
    
    private weak var navigationController: UINavigationController?
    private let viewControllerFactory: ViewControllerFactoryProtocol
    
    init(navigationController: UINavigationController, viewControllerFactory: ViewControllerFactoryProtocol){
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
    }
    
    func start() {
        let postVC = PostViewController()
        postVC.toInfoVC  = toInfoVC
        navigationController?.pushViewController(postVC, animated: true)
    }
    
    func toInfoVC(vc: UIViewController){
        let infoCoordinator = InfoCoordinator(vc,viewControllerFactory: viewControllerFactory)
        infoCoordinator.start()
    }
    
}
