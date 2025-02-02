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
        super.init()
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
            returnTap: headerView.leftBarButton.rx.tap,
            removeUser: removeUserSubject.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.userData
            .map { !$0.isEmpty }
            .withUnretained(self)
            .bind { (owner, hasData) in
                owner.tableView.isHidden = !hasData
                owner.contentHeader.isHidden = !hasData
                owner.emptyStateStack.isHidden = hasData
            }
            .disposed(by: disposeBag)
        
        // 테이블 뷰 연결
        output.userData
            .do(onNext: { [weak self] users in
                self?.updateCount(count: users.count)
            })
            .bind(to: tableView.rx.items(
                cellIdentifier: BlockedUserCell.reuseIdentifier,
                cellType: BlockedUserCell.self)
            ) { [weak self] (row, element, cell) in
                
                cell.configure(
                    title: element.nickname,
                    subTitle: element.instagramId ?? "",
                    imageURL: element.profileImage,
                    initialState: .blocked
                )
                
                // ToastMessage 출력
                cell.cellStateSubject
                    .skip(1)
                    .subscribe(onNext: { [weak self] state in
                        guard let self = self else { return }
                        switch state {
                        case .blocked:
                            self.viewModel.blokedUser.onNext(element)
                        case .unblocked:
                            self.viewModel.unblockedUser.onNext(element)
                        }
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        // 리턴 버튼 연결
        output.dismissScreen
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
