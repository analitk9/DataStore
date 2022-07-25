//
//  LoginViewCoordinator.swift
//  Navigation
//
//  Created by Denis Evdokimov on 1/24/22.
//

import UIKit
final class LoginViewCoordinator: Coordinator {
   // private let loginFactory = MyLoginFactory(typeOfServise: <#LoginService#>)
    private weak var navigationController: UINavigationController?
    private let viewControllerFactory: ViewControllerFactoryProtocol
    init(navigationController: UINavigationController, factory: ViewControllerFactoryProtocol){
        self.navigationController = navigationController
        self.viewControllerFactory = factory
    }
    
    
    
    func start() {
      //  let firebaseService = FirebaseService()
        let realmService = RealmService()
        let loginChecker = LoginInspector(loginservice: realmService)
        let model = LoginViewModel(loginChecker: loginChecker, bfService: BruteForceService(), toProfileVC: toProfileVC)
        
        let loginVC = viewControllerFactory.createController(type: .loginVC(model)) as! LogInViewController
 
        navigationController?.setViewControllers([loginVC], animated: false)
        
    }
    
    func toProfileVC(name: String){
        guard let navigationController = navigationController else { return }
        let profileCoordinator = ProfileViewCoordinator(viewControllerFactory: viewControllerFactory, navigationController: navigationController, name: name)
        profileCoordinator.start()
        
    }
}
