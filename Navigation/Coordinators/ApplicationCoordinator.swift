//
//  ApplicationCoordinator.swift
//  Navigation
//
//  Created by Denis Evdokimov on 1/24/22.
//

import Foundation
import UIKit

final class ApplicationCoordinator: BaseCoordinator, Coordinator {
    
    private let tabBarController: UITabBarController = {
        let tabBar = TabBarConfigurator().configure()
        return tabBar
    }()
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

        let loginNavigationVC = UINavigationController()

        let loginCoordinator = LoginViewCoordinator(navigationController: loginNavigationVC, factory: viewControllerFactory, tabController: tabBarController)
        loginNavigationVC.tabBarItem = tabBarController.viewControllers?[0].tabBarItem
        tabBarController.viewControllers?[0] = loginNavigationVC
        tabBarController.selectedViewController = tabBarController.viewControllers?.first
        addDependency(loginCoordinator)
        loginCoordinator.start()
    }
    
    private func initWindow() {
        let window = UIWindow(windowScene: scene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
}
