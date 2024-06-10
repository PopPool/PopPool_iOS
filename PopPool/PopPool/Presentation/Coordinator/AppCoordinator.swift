//
//  AppCoordinator.swift
//  PopPool
//
//  Created by Porori on 6/10/24.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    override func start() {
        let coordinator = MainCoordinator(navigationController: navigationController)
        moveToChild(coordinator: coordinator)
    }
}

class MainCoordinator: BaseCoordinator {
    
    override func start() {
        let rootViewModel = ViewControllerViewModel()
        let rootVC = ViewController(viewModel: rootViewModel)
        rootVC.coordinator = self
        navigationController.pushViewController(rootVC, animated: false)
    }
    
    func moveToSecondScreen() {
        removeChildCoordinators()
        let coordinator = ChildrenCoordinator(navigationController: navigationController)
        moveToChild(coordinator: coordinator)
    }
}
