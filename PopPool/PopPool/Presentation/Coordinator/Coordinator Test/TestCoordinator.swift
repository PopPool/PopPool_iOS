//
//  ChildrenCoordinator.swift
//  PopPool
//
//  Created by Porori on 6/10/24.
//

import UIKit

/// 두번째 화면을 담당하는 Coordinator입니다
/// pop와 present 방식을 실행할 수 있습니다
protocol TestCoordinatorDelegate {
    func popViewController()
    func presentViewController()
}

class TestCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    var delegate: TestCoordinatorDelegate?
    
    /// TestCoordinator 생성하는 메서드입니다
    override func start() {
        let viewModel = TestViewModel()
        let nextVC = TestVC(viewModel: viewModel)
        viewModel.delegate = self
        navigationController.pushViewController(nextVC, animated: true)
    }
}

extension TestCoordinator: TestVCDelegate {
    
    // MARK: - Methods
    
    /// 화면을 navigationController stack에서 내립니다
    func popViewController() {
        delegate?.popViewController()
    }
    
    /// 화면을 모달 방식으로 띄워줍니다
    func presentViewController() {
        delegate?.presentViewController()
    }
}
