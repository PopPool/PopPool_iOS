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
    
    // MARK: - Components
    
    private let viewModel: BlockedUserVM
    private let headerView = HeaderViewCPNT(title: "차단한 사용자 관리", style: .icon(nil))
    private lazy var contentHeader = ListMenuCPNT(titleText: "", style: .none)
    private let topSpaceView = UIView()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.tableHeaderView = UIView(frame: .zero)
        table.tableFooterView = UIView(frame: .zero)
        table.register(BlockedUserCell.self,
                       forCellReuseIdentifier: BlockedUserCell.reuseIdentifier)
        return table
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(headerView)
        stack.addArrangedSubview(topSpaceView)
        stack.addArrangedSubview(contentHeader)
        return stack
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "차단한 사용자가 없어요"
        label.font = .KorFont(style: .regular, size: 14)
        label.textAlignment = .center
        label.textColor = .g400
        return label
    }()
    
    private let emptyTopView = UIView()
    private let emptyBottomView = UIView()
    
    private var emptyStateStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
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
        setUp()
        setUpConstraints()
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
                cellType: BlockedUserCell.self)) { [weak self] (row, element, cell) in
                    
                    cell.configure(title: element.instagramId,
                                   subTitle: element.nickname,
                                   initialState: .blocked)
                    cell.selectionStyle = .none
                    
                    // ToastMessage 출력
                    cell.cellStateRelay
                        .subscribe(onNext: { [weak self] state in
                            guard let self = self else { return }
                            switch state {
                            case .blocked:
                                ToastMSGManager.createToast(message: "\(element.nickname)님을 차단했습니다.")
                            case .unblocked:
                                ToastMSGManager.createToast(message: "차단 해제 완")
                            }
                        })
                        .disposed(by: cell.disposeBag)
                }
                .disposed(by: disposeBag)
        
        // 리턴 버튼 연결
        output.returnTapped
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func updateCount(count: Int) {
        contentHeader.titleLabel.text = "총 \(count)건"
    }
    
    private func setUp() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        headerView.rightBarButton.isHidden = true
        contentHeader.iconButton.isHidden = true
    }
    
    private func setUpConstraints() {
        view.addSubview(stackView)
        view.addSubview(tableView)
        view.addSubview(emptyStateStack)
        emptyStateStack.addArrangedSubview(emptyTopView)
        emptyStateStack.addArrangedSubview(emptyLabel)
        emptyStateStack.addArrangedSubview(emptyBottomView)
        
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
        
        emptyTopView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.large200)
        }
        
        emptyBottomView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.large200)
        }
        
        emptyStateStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentHeader.snp.bottom)
        }
    }
}
