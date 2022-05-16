//
//  ApplicationCoordinator.swift
//  Navigation
//
//  Created by Denis Evdokimov on 1/24/22.
//

import Foundation
import UIKit

final class ApplicationCoordinator: BaseCoordinator, Coordinator {
    
    private let tabBarController = UITabBarController()
    private var window: UIWindow?
    private let scene: UIWindowScene
    private let viewControllerFactory: ViewControllerFactoryProtocol
    init(scene: UIWindowScene, factory: ViewControllerFactoryProtocol) {
        self.scene = scene
        self.viewControllerFactory = factory
        super.init()
    }
    
    func start() {
        initWindow()
        
        let feedNavigationVC = UINavigationController()
        let loginNavigationVC = UINavigationController()
        let mediaVC = MediaViewController()
        let favouritesNavigationVC = UINavigationController(rootViewController:  FavouritesViewController())
        
        let feedCoordinator = FeedViewCoordinator(navigationController: feedNavigationVC,factory: viewControllerFactory)
        let loginCoordinator = LoginViewCoordinator(navigationController: loginNavigationVC, factory: viewControllerFactory)
        
        tabBarController.setViewControllers([feedNavigationVC,loginNavigationVC,mediaVC,favouritesNavigationVC], animated: true)
        tabBarController.selectedViewController = tabBarController.viewControllers?.first
        addDependency(feedCoordinator)
        addDependency(loginCoordinator)
        
        feedCoordinator.start()
        loginCoordinator.start()
    }
    
    private func initWindow() {
        let window = UIWindow(windowScene: scene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
}
