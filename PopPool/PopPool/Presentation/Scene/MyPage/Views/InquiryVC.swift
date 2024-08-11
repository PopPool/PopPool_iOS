//
//  InquiryVC.swift
//  PopPool
//
//  Created by Porori on 8/3/24.
//

import UIKit
import RxSwift
import SnapKit

class InquiryVC: UIViewController {
    
    let headerView = HeaderViewCPNT(title: "고객문의", style: .icon(nil))
    let tableView = UITableView()
    private let disposeBag = DisposeBag()
    private let viewModel: InquiryVM
    
    init(viewModel: InquiryVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setUp()
        setUpConstraint()
        bind()
    }
    
    private func bind() {
        let input = InquiryVM.Input()
        let output = viewModel.transform(input: input)
        
        headerView.leftBarButton.rx.tap
            .subscribe(onNext: {
                print("뒤돌아가기")
            })
            .disposed(by: disposeBag)
        
        output.data
            .bind(to: tableView.rx.items(
                cellIdentifier: InquiryTableViewCell.reuseIdentifier,
                cellType: InquiryTableViewCell.self)) { index, element, cell in
                    cell.dropDownList.configure(title: element, content: element)
                }
                .disposed(by: disposeBag)
    }
    
    private func setUp() {
        navigationController?.navigationBar.isHidden = true
        tableView.backgroundColor = .yellow
        tableView.separatorStyle = .none
        tableView.register(InquiryTableViewCell.self,
                           forCellReuseIdentifier: InquiryTableViewCell.reuseIdentifier)
    }
    
    private func setUpConstraint() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
