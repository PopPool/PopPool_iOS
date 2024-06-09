//
//  ChildrenCoordinator.swift
//  PopPool
//
//  Created by Porori on 6/10/24.
//

import UIKit

class ChildrenCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: AppCoordinator?
    var childCoordinator: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // let nextVC = someVC()
        // nextVC.coordinator = self
        //navigationController.pushViewController(nextVC, animated: true)
    }
}
