//
//  BlockedUserVC.swift
//  PopPool
//
//  Created by Porori on 7/23/24.
//

import UIKit
import SnapKit
import RxSwift

final class BlockedUserVC: UIViewController {
    
    let viewModel: BlockedUserVM
    let headerView = HeaderViewCPNT(title: "차단한 사용자 관리", style: .icon(nil))
    lazy var contentHeader = ListMenuCPNT(titleText: "총 \(viewModel.userDataRelay.value.count)건", style: .none)
    let topSpaceView = UIView()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.tableHeaderView = UIView(frame: .zero)
        table.tableFooterView = UIView(frame: .zero)
        table.register(BlockedUserCell.self,
            forCellReuseIdentifier: BlockedUserCell.reuseIdentifier)
        return table
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(headerView)
        stack.addArrangedSubview(topSpaceView)
        stack.addArrangedSubview(contentHeader)
        return stack
    }()
    
    private let disposeBag = DisposeBag()
    // Observable.of는 0이라는 값을 출력만 하다가 사라진다. 계속 감시해야하는 상황과 다르다?
    private let removeUserSubject = PublishSubject<Int>()
    
    init(viewModel: BlockedUserVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = BlockedUserVM.Input(
            returnTap: headerView.leftBarButton.rx.tap,
            removeUser: removeUserSubject.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        // 테이블 뷰 연결
        output.userData
            .bind(to: tableView.rx.items(
                cellIdentifier: BlockedUserCell.reuseIdentifier,
                cellType: BlockedUserCell.self)) { (row, element, cell) in
                cell.setStyle(title: element.instagramId,
                              subTitle: element.nickname,
                              style: .button("차단 완료"))
                
                // cell 내부 remove 버튼 연결
                cell.removeButton.rx.tap
                        .compactMap { [weak self] _ in
                            guard let indexPath = self?.tableView.indexPath(for: cell) else { return -1 }
                            return indexPath.row
                        }
                    .bind(to: self.removeUserSubject)
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        
        // 리턴 버튼 연결
        output.returnTapped
            .withUnretained(self)
            .subscribe { (owner, _) in
                print("버튼이 눌렸습니다")
            }
            .disposed(by: disposeBag)
    }
    
    private func setUp() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        headerView.rightBarButton.isHidden = true
    }
    
    private func setUpConstraints() {
        view.addSubview(stackView)
        view.addSubview(tableView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        topSpaceView.snp.makeConstraints { make in
            make.height.equalTo(12)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}
