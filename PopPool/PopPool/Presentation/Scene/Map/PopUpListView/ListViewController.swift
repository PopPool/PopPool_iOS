//  ListViewController.swift
//  PopPool
//
//  Created by 김기현 on 8/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
    private let viewModel: MapVM
    private let disposeBag = DisposeBag()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PopupListCell.self, forCellReuseIdentifier: PopupListCell.identifier)
        return tableView
    }()

    init(viewModel: MapVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func bindViewModel() {
        viewModel.output.filteredStores
            .bind(to: tableView.rx.items(cellIdentifier: PopupListCell.identifier, cellType: PopupListCell.self)) { (row, store, cell) in
                cell.configure(with: store)
            }
            .disposed(by: disposeBag)
    }
}
