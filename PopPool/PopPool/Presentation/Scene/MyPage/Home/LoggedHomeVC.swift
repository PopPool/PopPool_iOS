//
//  LoggedHomeVC.swift
//  PopPool
//
//  Created by Porori on 8/12/24.
//

import UIKit
import RxSwift
import SnapKit

final class LoggedHomeVC: BaseViewController {
    
    enum Section: CaseIterable {
        case header
        case recommended
        case interest
        case new
    }
    
//    private lazy var profileView = MyPageMainProfileView(
//        frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: self.profileViewHeight)
//    )
    
    let header = HeaderViewCPNT(title: "교체 예정", style: .icon(nil))
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.tableFooterView = UIView(frame: .zero)
        return view
    }()
    
    private let viewModel: HomeVM
    
    init(viewModel: HomeVM) {
        self.viewModel = viewModel
        super.init()
        setUp()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = nil
//        tableView.register(HomeListCell.self,
//                           forCellReuseIdentifier: HomeListCell.reuseIdentifier)
    }
    
    private func setUpConstraint() {
        navigationController?.navigationBar.isHidden = true
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(header)
        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}

extension LoggedHomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return Section.allCases.count
//    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .red
        return cell
    }
}
