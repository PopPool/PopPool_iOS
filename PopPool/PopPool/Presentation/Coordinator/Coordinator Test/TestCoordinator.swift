//
//  TestCoordinator.swift
//  PopPool
//
//  Created by Porori on 6/13/24.
//

import UIKit

protocol TestCoordinatorDelegate {
    func popViewController()
    func presentViewController()
}

class TestCoordinator: BaseCoordinator {
    var delegate: TestCoordinatorDelegate?
    
    override func start() {
        let testViewModel = TestViewModel()
        let nextVC = TestVC(viewModel: testViewModel)
        testViewModel.delegate = self
        navigationController.pushViewController(nextVC, animated: true)
    }
}

extension TestCoordinator: TestVCDelegate {
    func popViewController() {
        delegate?.popViewController()
    }
    
    func presentViewController() {
        delegate?.presentViewController()
    }
}
