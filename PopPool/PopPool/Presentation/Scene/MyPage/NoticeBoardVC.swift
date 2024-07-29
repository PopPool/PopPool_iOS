//
//  NoticeBoardVC.swift
//  PopPool
//
//  Created by Porori on 7/29/24.
//

import UIKit
import SnapKit
import RxSwift

class NoticeBoardVC: BaseTableViewVC {
    
    private let viewModel: NoticeBoardVM
    private let noticeSelectSubject = PublishSubject<IndexPath>()
    
    init(viewModel: NoticeBoardVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
    
    private func bind() {
        let input = NoticeBoardVM.Input(
            selectedNotice: noticeSelectSubject.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        // 셀 등록
        output.notices
            .bind(to: tableView.rx.items(
                cellIdentifier: NoticeTableViewCell.reuseIdentifier,
                cellType: NoticeTableViewCell.self)) { [weak self] (row, element, cell) in
                    print("이건 어딘데", cell)
            }
            .disposed(by: disposeBag)
        
        // 테이블 뷰 데이터 전달
        tableView.rx.itemSelected
            .bind(to: noticeSelectSubject)
            .disposed(by: disposeBag)
        
        // 테이블 뷰 되돌아가기 버튼
        headerView.leftBarButton.rx.tap
            .withUnretained(self)
            .bind { _ in
                print("navigationController에서 되돌아갑니다")
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setUp() {
        tableView.register(NoticeTableViewCell.self,
                           forCellReuseIdentifier: NoticeTableViewCell.reuseIdentifier)
        headerView.titleLabel.text = "공지사항"
        emptyLabel.removeFromSuperview()
    }
}
