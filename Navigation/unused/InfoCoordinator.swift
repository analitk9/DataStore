//
//  InfoCoordinator.swift
//  Navigation
//
//  Created by Denis Evdokimov on 1/24/22.
//

import UIKit

final class InfoCoordinator: Coordinator {
    
    private let viewController: UIViewController
    private let viewControllerFactory: ViewControllerFactoryProtocol
    init(_ vc: UIViewController, viewControllerFactory: ViewControllerFactoryProtocol){
        self.viewControllerFactory = viewControllerFactory
        self.viewController = vc
    }
    
    
    func start() {
        let vc = InfoViewController()
        vc.modalPresentationStyle = .formSheet
        viewController.present(vc, animated: true, completion: nil)
    }
    
}
