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
    
    /// 화면을 모달 방식으로 보여줍니다
    /// 현재 테스트를 위해 구현한 코드인만큼 navigationStack 위로 온전히 올라가지 않았습니다
    /// 따라서 modal viewController에서 탭된 버튼 액션 또한 navigationStack에 올바르게 올라가지 않습니다
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
