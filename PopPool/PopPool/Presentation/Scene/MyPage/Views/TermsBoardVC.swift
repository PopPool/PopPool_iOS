//
//  TermsBoardVC.swift
//  PopPool
//
//  Created by Porori on 7/31/24.
//

import UIKit
import SnapKit
import RxSwift

class TermsBoardVC: BaseTableViewVC {
    
    let viewModel: TermsBoardVM
    
    init(viewModel: TermsBoardVM) {
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
        
        output.terms
            .map { !$0.isEmpty }
            .withUnretained(self)
            .subscribe(onNext: { owner, hasData in
                owner.emptyStateStack.isHidden = hasData
            })
            .disposed(by: disposeBag)
        
        output.terms
            .do(onNext: { [weak self] term in
                self?.updateView(data: term.count)
            })
             // 테이블 뷰 연결
            .bind(to: tableView.rx.items(
                cellIdentifier: NoticeTableViewCell.reuseIdentifier,
                cellType: NoticeTableViewCell.self)) { row, element, cell in
                    
                    cell.updateView(title: element[0],
                                    subTitle: nil)
                }
                .disposed(by: disposeBag)
        
        output.selectedTerm
            .subscribe(onNext: { [weak self] term in
                print("\(term) term이 눌렸습니다.")
                let vc = TermsDetailBoardVC(viewModel: TermsDetailBoardVM())
                self?.presentModalViewController(viewController: vc)
            })
            .disposed(by: disposeBag)

        output.returnButtonTapped
            .subscribe(onNext: { [weak self] in
                print("뒤돌아가기 버튼이 눌렸습니다")
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
