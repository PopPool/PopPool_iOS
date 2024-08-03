//
//  TermsBoardVC.swift
//  PopPool
//
//  Created by Porori on 7/31/24.
//

import UIKit
import SnapKit
import RxSwift

final class TermsBoardVC: BaseTableViewVC {
    
    // MARK: - Properties
    
    private let viewModel: TermsBoardVM
    
    // MARK: - Initializer
    
    init(viewModel: TermsBoardVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
    
    // MARK: - Methods
    
    private func setUp() {
        tableView.register(NoticeTableViewCell.self,
                           forCellReuseIdentifier: NoticeTableViewCell.reuseIdentifier)
    }
    
    private func updateView(data: Int) {
        contentHeader.updateView(count: data)
    }
    
    private func bind() {
        
        let input = TermsBoardVM.Input(
            returnButtonTapped: headerView.leftBarButton.rx.tap,
            termSelected: tableView.rx.itemSelected.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        // 데이터 존재 여부에 따라 emptyState 안내
        output.terms
            .map { !$0.isEmpty }
            .withUnretained(self)
            .subscribe(onNext: { owner, hasData in
                owner.emptyStateStack.isHidden = hasData
            })
            .disposed(by: disposeBag)
        
        // 데이터를 테이블 뷰에 제공
        output.terms
            .do(onNext: { [weak self] term in
                self?.updateView(data: term.count)
            })
            .bind(to: tableView.rx.items(
                cellIdentifier: NoticeTableViewCell.reuseIdentifier,
                cellType: NoticeTableViewCell.self)) { row, element, cell in
                    
                    // NoticeDTO 활용하여 변경 예정
                    cell.updateView(title: element[0],
                                    subTitle: nil)
                }
                .disposed(by: disposeBag)
        
        // 선택된 공지사항 출력
        output.selectedTerm
            .subscribe(onNext: { [weak self] term in
                let vc = TermsDetailBoardVC(viewModel: TermsDetailBoardVM())
                vc.configure(with: term)
                self?.presentModalViewController(viewController: vc)
            })
            .disposed(by: disposeBag)

        output.returnButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
