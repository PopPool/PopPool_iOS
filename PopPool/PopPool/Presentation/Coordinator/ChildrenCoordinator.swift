//
//  ChildrenCoordinator.swift
//  PopPool
//
//  Created by Porori on 6/10/24.
//

import UIKit

class ChildrenCoordinator: BaseCoordinator {
    
    override func start() {
        let viewModel = ViewControllerViewModel()
        let nextVC = TestVC(viewModel: viewModel)
        nextVC.coordinator = self
        navigationController.pushViewController(nextVC, animated: true)
    }
    
    func pushToChild() {
        removeChildCoordinators()
        let coordinator = ChildrenCoordinator(navigationController: navigationController)
        moveToChild(coordinator: coordinator)
    }
}
