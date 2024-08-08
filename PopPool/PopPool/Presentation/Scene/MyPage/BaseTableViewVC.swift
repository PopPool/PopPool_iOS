//
//  BaseTableViewVC.swift
//  PopPool
//
//  Created by Porori on 7/29/24.
//

import UIKit
import SnapKit
import RxSwift

class BaseTableViewVC: BaseViewController {
    
    // MARK: - Components
    
    let headerView = HeaderViewCPNT(title: "차단한 사용자 관리", style: .icon(nil))
    lazy var contentHeader = ListMenuCPNT(titleText: "", style: .none)
    private let topSpaceView = UIView()
    
    let tableView: UITableView = {
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
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "차단한 사용자가 없어요"
        label.font = .KorFont(style: .regular, size: 14)
        label.textAlignment = .center
        label.textColor = .g400
        return label
    }()
    
    private let emptyTopView = UIView()
    private let emptyBottomView = UIView()
    
    var emptyStateStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
    }
    
    // MARK: - Method
    
    func updateCount(count: Int) {
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
