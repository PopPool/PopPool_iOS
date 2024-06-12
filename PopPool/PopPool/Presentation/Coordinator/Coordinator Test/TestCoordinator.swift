//
//  ChildrenCoordinator.swift
//  PopPool
//
//  Created by Porori on 6/10/24.
//

import UIKit

protocol TestCoordinatorDelegate {
    func popViewController()
}

class TestCoordinator: BaseCoordinator, TestVCDelegate {
    
    var delegate: TestCoordinatorDelegate?
    
    override func start() {
        let viewModel = ViewControllerViewModel()
        let nextVC = TestVC(viewModel: viewModel)
        nextVC.delegate = self
        navigationController.pushViewController(nextVC, animated: true)
    }
    
    func popViewController() {
        delegate?.popViewController()
    }
}
