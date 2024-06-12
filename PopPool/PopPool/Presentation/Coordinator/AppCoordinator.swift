//
//  AppCoordinator.swift
//  PopPool
//
//  Created by Porori on 6/10/24.
//

import UIKit

/// 앱의 초기 Coordinator 연결부입니다
class AppCoordinator: BaseCoordinator {
    
    // MainCoordinator를 연결합니다
    override func start() {
        
        /// BaseCoordinator를 적용하지 않는 이유
            // BaseCoordinator의 역할은 메서드들을 일일히 선언하지 않는 편의성을 위함입니다
            // AppCoordinator의 start() 메서드 안에 BaseCoordinator를 담을 경우
            // BaseCoordinator 자체는 값이 없기 때문에 화면이 보이지 않게 됩니다.
            
            // 또한 BaseCoordinator에는 '화면 전환' 메서드를 가지고 있지에
            // baseCoordinator를 한번 더 감싼 MainCoordinator를 적용합니다
              
        /// BaseCoordinator에 rootViewController를 선언하지 않는 이유
            // 아래와 같이 코드를 직접 선언할 경우, root.coordinator 대리자 문제가 발생합니다
            // AppCoordinator > MainCoordinator > BaseCoordinator 인 구조이기에
            // 최상위 coordinator 역할을 App에게 위임할 경우,
            // ViewController가 가지고 있는 coordinator 델리게이트 역할을 위임 시킬 수 있는 객체가 없습니다
                  
            // let rootViewModel = ViewControllerViewModel()
            // let root = ViewController(viewModel: rootViewModel)
            // root.coordinator = self
        showHomeScreen()
    }
    
    func showHomeScreen() {
        let coordinator = HomeCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        childCoordinator.append(coordinator)
    }
}

extension AppCoordinator: HomeCoordinatorDelegate {
        func pushToNextViewController() {
            let coordinator = TestCoordinator(navigationController: navigationController)
            coordinator.delegate = self
            coordinator.start()
            childCoordinator.append(coordinator)
        }
}

extension AppCoordinator: TestCoordinatorDelegate {
    func popViewController() {
        navigationController.popViewController(animated: true)
        childCoordinator.removeLast()
    }
}
