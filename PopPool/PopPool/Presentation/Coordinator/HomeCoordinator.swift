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
        homeViewModel.delegate = self

        navigationController.viewControllers = [homeViewController]
    }
    
    func presentStart() {
        print("present 방식으로 생성")
        let homeViewModel = ViewControllerViewModel()
        let homeViewController = ViewController(viewModel: homeViewModel)
        homeViewModel.delegate = self

        homeViewController.modalPresentationStyle = .formSheet
        navigationController.present(homeViewController, animated: true)
    }
}

extension HomeCoordinator: HomeCoordinatorDelegate {
    func pushToNextViewController() {
        delegate?.pushToNextViewController()
    }
}
