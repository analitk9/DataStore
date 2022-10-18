//
//  FeedViewCoordinator.swift
//  Navigation
//
//  Created by Denis Evdokimov on 1/24/22.
//

import UIKit

final class FeedViewCoordinator: Coordinator {
    
    private weak var navigationController: UINavigationController?
    private let viewControllerFactory: ViewControllerFactoryProtocol
    
    init(navigationController: UINavigationController, factory: ViewControllerFactoryProtocol){
        self.viewControllerFactory = factory
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = FeedViewModel()
        let feedVC = viewControllerFactory.createController(type: .feedVC(viewModel)) as! FeedViewController
        navigationController?.setViewControllers([feedVC], animated: false)
        viewModel.toPostVС = showPostVc
    }
    
    func showPostVc(){
        guard let navigationController = navigationController else { return }
        let postCoordinator = PostViewCoordinator(navigationController: navigationController, viewControllerFactory: viewControllerFactory)
        postCoordinator.start()
    }
    
    
}

