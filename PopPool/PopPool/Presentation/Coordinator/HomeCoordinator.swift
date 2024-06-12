//
//  HomeCoordinator.swift
//  PopPool
//
//  Created by Porori on 6/13/24.
//

import Foundation

protocol HomeCoordinatorDelegate {
    func pushToNextViewController()
}

class HomeCoordinator: BaseCoordinator, HomeViewControllerDelegate {
    var delegate: HomeCoordinatorDelegate?
    
    override func start() {
        print("홈 화면 생성 필요")
        let homeViewModel = ViewControllerViewModel()
        let homeViewController = ViewController(viewModel: homeViewModel)
        homeViewController.delegate = self
        
        navigationController.viewControllers = [homeViewController]
    }
}

extension HomeCoordinator: HomeCoordinatorDelegate {
    func pushToNextViewController() {
        delegate?.pushToNextViewController()
    }
}
