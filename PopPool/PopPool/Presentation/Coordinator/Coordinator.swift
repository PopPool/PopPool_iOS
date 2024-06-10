//
//  Coordinator.swift
//  PopPool
//
//  Created by Porori on 6/9/24.
//

import UIKit

/// Coordinator의 기본 구성입니다
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    func moveToChild(coordinator: Coordinator)
    func removeChildCoordinators()
}

/// Coordinator를 채택한 BaseCoordinator입니다
/// 모든 Coordinator는 해당 Base를 채택하여 적용하면 됩니다
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
    
    // coordinator를 연결 짓기 위한 필수 메서드입니다
    // override func start()로 사용해주세요
    func start() {
        print("코디네이터 연결이 필요합니다")
    }
    
    // 하위 Coordinator를 연결합니다
    func moveToChild(coordinator: Coordinator) {
        childCoordinator.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    // 하위 Coordinator를 제거합니다
    func removeChildCoordinators() {
        childCoordinator.forEach { $0.removeChildCoordinators() }
        childCoordinator.removeAll()
    }
}
