//
//  NoticeBoardVC.swift
//  PopPool
//
//  Created by Porori on 7/29/24.
//

import UIKit
import SnapKit
import RxSwift

final class NoticeBoardVC: BaseTableViewVC {
    
    // MARK: - Properties
    
    private let viewModel: NoticeBoardVM
    
    // MARK: - Initializer
    
    init(viewModel: NoticeBoardVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCell()
        bind()
    }
    
    // MARK: - Method
    
    /// 공지사항 안내 건 수와 View의 메인 제목을 변경하기 위한 메서드입니다
    /// - Parameter notice: 공지사항 총 갯수 파악이 필요하여 Int를 받습니다
    private func updateView(notice: Int) {
        headerView.titleLabel.text = "공지사항"
        emptyLabel.text = "아직 등록된 공지사항이 없어요"
        
        // 이전에 작성한 코드와 비교 이후 아래 코드 삭제 여부 판단 필요
        contentHeader.titleLabel.text = "총 \(notice) 건"
        contentHeader.iconButton.isHidden = true
    }
    
    /// BaseTableViewVC과 다른 테이블뷰 셀을 등록할 수 있는 메서드입니다
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
        
        output.notices
            .map { !$0.isEmpty }
            .withUnretained(self)
            .bind { (owner, hasData) in
                owner.tableView.isHidden = !hasData
                owner.contentHeader.isHidden = !hasData
                owner.emptyStateStack.isHidden = hasData
            }
            .disposed(by: disposeBag)
        
        // 셀에 공지사항 데이터를 제공합니다
        // 더미 데이터로 구성하여 데이터 구조는 변경할 예정입니다
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
        
        // 선택된 데이터로 화면을 이동합니다
        output.selectedNotice
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                let detailBoardVM = NoticeDetailBoardVM(data: data)
                let detailVC = NoticeDetailBoardVC(viewModel: detailBoardVM)
                owner.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 해당 공지사항 페이지에서 rootViewController로 나갑니다
        output.popToRoot
            .subscribe(onNext: { [weak self] in
                print("root로 돌아갑니다")
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
