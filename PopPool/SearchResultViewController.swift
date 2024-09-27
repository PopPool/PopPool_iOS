//
//  SearchResultViewController.swift
//  PopPool
//
//  Created by 김기현 on 9/24/24.
//

import Foundation
import UIKit
import RxSwift


class SearchResultViewController: UIViewController {
    private let searchViewModel: SearchViewModel
    private let suggestionTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        return tableView
    }()

    private let disposeBag = DisposeBag()

    init(viewModel: SearchViewModel) {
        self.searchViewModel = viewModel
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
        view.addSubview(suggestionTableView)
        suggestionTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func bindViewModel() {
        searchViewModel.output.realTimeSuggestions
            .observe(on: MainScheduler.instance)
            .bind(to: suggestionTableView.rx.items(cellIdentifier: "SearchResultCell")) { index, suggestion, cell in
                cell.textLabel?.text = suggestion.name
            }
            .disposed(by: disposeBag)

        // 테이블 셀 선택 시 상세 페이지로 이동
//        suggestionTableView.rx.itemSelected
//            .subscribe(onNext: { [weak self] indexPath in
//                let suggestion = self?.searchViewModel.output.realTimeSuggestions.value[indexPath.row]
//                // 상세 페이지로 이동 로직
//            })
//            .disposed(by: disposeBag)
    }
}
