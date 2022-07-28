//
//  LoginViewCoordinator.swift
//  Navigation
//
//  Created by Denis Evdokimov on 1/24/22.
//

import UIKit


final class LoginViewCoordinator: Coordinator {
   // private let loginFactory = MyLoginFactory(typeOfServise: <#LoginService#>)
    private let tabController: UITabBarController
    private weak var navigationController: UINavigationController?
    private let viewControllerFactory: ViewControllerFactoryProtocol
    init(navigationController: UINavigationController, factory: ViewControllerFactoryProtocol, tabController: UITabBarController){
        self.navigationController = navigationController
        self.viewControllerFactory = factory
        self.tabController = tabController
    }
    
    
    
    func start() {
        let loginChecker = LoginInspector(loginservice: .realm)
        let localAuthService = LocalAuthorizationService()
        let model = LoginViewModel(loginChecker: loginChecker, localAuthService: localAuthService, toProfileVC: toProfileVC)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        appDelegate?.localNotifications.delegate = model
        let loginVC = viewControllerFactory.createController(type: .loginVC(model)) as! LogInViewController
    
        navigationController?.setViewControllers([loginVC], animated: false)
        
    }
    
    func toProfileVC(name: String, isSwitchTabBar: Bool ) {
       
        guard let navigationController = navigationController else { return }
        if isSwitchTabBar {
            tabController.selectedViewController = navigationController
        }
        let profileCoordinator = ProfileViewCoordinator(viewControllerFactory: viewControllerFactory, navigationController: navigationController, name: name)
        profileCoordinator.start()
        
    }
}
