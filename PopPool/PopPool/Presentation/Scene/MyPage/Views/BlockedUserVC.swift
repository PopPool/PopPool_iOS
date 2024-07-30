//
//  BlockedUserVC.swift
//  PopPool
//
//  Created by Porori on 7/23/24.
//

import UIKit
import SnapKit
import RxSwift

final class BlockedUserVC: BaseTableViewVC {
    
    // MARK: - Components
    
    private let viewModel: BlockedUserVM
    
    // MARK: - Properties
    private let removeUserSubject = PublishSubject<Int>()
    
    // MARK: - Initializer
    
    init(viewModel: BlockedUserVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - Methods
    
    private func bindViewModel() {
        let input = BlockedUserVM.Input(
            returnTap: headerView.leftBarButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.userData
            .map { !$0.isEmpty }
            .withUnretained(self)
            .bind { (owner, hasData) in
                owner.tableView.isHidden = !hasData
                owner.emptyStateStack.isHidden = hasData
            }
            .disposed(by: disposeBag)
        
//        // 테이블 뷰 연결
        output.userData
            .do(onNext: { user in
                self.updateCount(count: user.count)
            })
            .bind(to: tableView.rx.items(
                    cellIdentifier: BlockedUserCell.reuseIdentifier,
                    cellType: BlockedUserCell.self)) { (row, users, cell) in
                        cell.selectionStyle = .none
                        cell.configure(
                            title: users[0],
                            subTitle: users[2],
                            initialState: .blocked)
                    }.disposed(by: disposeBag)
        
//        output.userData
//            .do(onNext: { [weak self] users in
//                self?.updateCount(count: users.count)
//            })
//            .bind(to: tableView.rx.items(
//                cellIdentifier: BlockedUserCell.reuseIdentifier,
//                cellType: BlockedUserCell.self)) { [weak self] (row, element, cell) in
//                    
//                    cell.configure(title: element.instagramId,
//                                   subTitle: element.nickname,
//                                   initialState: .blocked)
//                    cell.selectionStyle = .none
//                    
//                    // ToastMessage 출력
//                    cell.cellStateRelay
//                        .subscribe(onNext: { [weak self] state in
//                            guard let self = self else { return }
//                            switch state {
//                            case .blocked:
//                                ToastMSGManager.createToast(message: "\(element.nickname)님을 차단했습니다.")
//                            case .unblocked:
//                                ToastMSGManager.createToast(message: "차단 해제 완")
//                            }
//                        })
//                        .disposed(by: cell.disposeBag)
//                }
//                .disposed(by: disposeBag)
//        
        // 리턴 버튼 연결
        output.dismissScreen
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
