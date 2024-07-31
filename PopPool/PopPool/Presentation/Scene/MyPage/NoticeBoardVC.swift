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
        registerTableViewCell()
        bind()
    }
    
    private func updateView(notice: Int) {
        emptyLabel.removeFromSuperview()
        headerView.titleLabel.text = "공지사항"
        
        // 이전에 작성한 코드와 비교 이후 아래 코드 삭제 여부 판단 필요
        contentHeader.titleLabel.text = "총 \(notice) 건"
        contentHeader.iconButton.isHidden = true
    }
    
    private func registerTableViewCell() {
        tableView.register(NoticeTableViewCell.self,
                           forCellReuseIdentifier: NoticeTableViewCell.reuseIdentifier)
    }
    
    private func bind() {
        let input = NoticeBoardVM.Input(
            returnTapped: headerView.leftBarButton.rx.tap,
            selectedCell: tableView.rx.itemSelected.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        // 셀 등록
        output.notices
            .do(onNext: { [weak self] notice in
                self?.updateView(notice: notice.count)
            })
            .bind(to: tableView.rx.items(
                cellIdentifier: NoticeTableViewCell.reuseIdentifier,
                cellType: NoticeTableViewCell.self)) { (row, element, cell) in
                    cell.selectionStyle = .none
                    cell.updateView(title: element[0],
                                    subTitle: element[1])
                }
                .disposed(by: disposeBag)
        
        output.selectedNotice
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                let detailBoardVM = NoticeDetailBoardVM(data: data)
                let detailVC = NoticeDetailBoardVC(viewModel: detailBoardVM)
                owner.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 이전 화면으로 되돌아가기
        output.popToRoot
            .subscribe(onNext: { [weak self] in
                print("root로 돌아갑니다")
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
