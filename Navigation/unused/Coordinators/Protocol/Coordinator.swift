//
//  Coordinator.swift
//  Navigation
//
//  Created by Denis Evdokimov on 1/24/22.
//


protocol Coordinator: AnyObject {
    func start()
}

protocol FinishingCoordinator: Coordinator {
    var onFinish: (() -> Void)? { get set }
}
