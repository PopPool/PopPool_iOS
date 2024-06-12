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
        let viewModel = TestViewModel()
        let nextVC = TestVC(viewModel: viewModel)
        viewModel.delegate = self
        navigationController.pushViewController(nextVC, animated: true)
    }
    
    func popViewController() {
        delegate?.popViewController()
    }
}
