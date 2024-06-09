//
//  Coordinator.swift
//  PopPool
//
//  Created by Porori on 6/9/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinator: [Coordinator] { get set }
    func start()
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinator: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    func start() {
        let rootViewModel = ViewControllerViewModel()
        let rootVC = ViewController(viewModel: rootViewModel)
        rootVC.coordinator = self
        navigationController.pushViewController(rootVC, animated: false)
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinator.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinator = childCoordinator.filter { $0 !== coordinator }
    }
}
