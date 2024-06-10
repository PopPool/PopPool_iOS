//
//  Coordinator.swift
//  PopPool
//
//  Created by Porori on 6/9/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    func moveToChild(coordinator: Coordinator)
    func removeChildCoordinators()
}

class BaseCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []
    
    
    // MARK: - init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    // MARK: - Methods
    
    func start() {
        print("코디네이터 연결이 필요합니다")
    }
    
    func moveToChild(coordinator: Coordinator) {
        childCoordinator.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func removeChildCoordinators() {
        childCoordinator.forEach { $0.removeChildCoordinators() }
        childCoordinator.removeAll()
    }
}
