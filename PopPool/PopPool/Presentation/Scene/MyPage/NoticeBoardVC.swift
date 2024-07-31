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
            returnTapped: headerView.leftBarButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        // 셀 등록
        output.notices
            .bind(to: tableView.rx.items(
                cellIdentifier: NoticeTableViewCell.reuseIdentifier,
                cellType: NoticeTableViewCell.self)) { [weak self] (row, element, cell) in
                    cell.selectionStyle = .none
                    cell.updateView(title: element[0],
                                    subTitle: element[1])
                    
                    cell.actionButton.rx.tap
                        .subscribe(onNext: {
                            // navigationController push
                            print("\(row), indexPath의 버튼이 눌렸습니다.")
                        })
                        .disposed(by: cell.disposeBag)
                }
                .disposed(by: disposeBag)
        
        // 이전 화면으로 되돌아가기
        output.popToRoot
            .subscribe(onNext: { [weak self] in
                print("root로 돌아갑니다")
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setUp() {
        tableView.register(NoticeTableViewCell.self,
                           forCellReuseIdentifier: NoticeTableViewCell.reuseIdentifier)
        headerView.titleLabel.text = "공지사항"
        emptyLabel.removeFromSuperview()
    }
}
