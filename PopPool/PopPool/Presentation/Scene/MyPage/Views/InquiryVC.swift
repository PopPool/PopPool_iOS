//
//  InquiryVC.swift
//  PopPool
//
//  Created by Porori on 8/3/24.
//

import UIKit
import RxSwift
import SnapKit
import RxRelay

final class InquiryVC: UIViewController {
    
    private let headerView = HeaderViewCPNT(title: "고객문의", style: .icon(nil))
    private let topSpaceView = UIView()
    private let tableView = UITableView()
    private let moveToMailView = ListMenuCPNT(titleText: "메일로 문의", style: .none)
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
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
        view.backgroundColor = .systemBackground
        setUp()
        setUpConstraint()
        bind()
    }
    
    private func bind() {
        let buttonTaps = PublishRelay<IndexPath>()
        
        let input = InquiryVM.Input(
            questionTapped: buttonTaps.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        headerView.leftBarButton.rx.tap
            .subscribe(onNext: {
                print("뒤돌아가기")
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        moveToMailView.iconButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let test = "test@gmail.com"
                self?.openEmail(emailAccount: test)
            })
            .disposed(by: disposeBag)
        
        output.data
            .bind(to: tableView.rx.items(
                cellIdentifier: InquiryTableViewCell.reuseIdentifier,
                cellType: InquiryTableViewCell.self)) { [weak self] index, element, cell in
                    let indexPath = IndexPath(row: index, section: 0)
                    cell.configure(at: indexPath, buttonTaps: buttonTaps)
                    cell.dropDownList.configure(title: element, content: element)
                    
//                    if index == 0 {
//                        let headerView = self?.createHeader()
//                        headerView.frame = CGRect(x: 0, y: 0, width: self?.tableView.frame.width ?? 0, height: 50)
//                        self?.tableView.tableHeaderView = headerView
//                    }
                }
                .disposed(by: disposeBag)
        
        output.openQuestion
            .subscribe(onNext: { [weak self] indexPath in
                print("noolim \(indexPath)")
                self?.handleQuestionTap(at: indexPath)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func openEmail(emailAccount: String) {
        if let url = URL(string: "mailto:\(emailAccount)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func handleQuestionTap(at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? InquiryTableViewCell else { return }
        cell.dropDownList.buttonStateObserver.onNext(.active)
    }
    
    private func createHeader(title: String) -> UIView {
        let sectionHeader = ListTitleViewCPNT(title: title,
                                              size: .large(subtitle: "", image: nil))
        sectionHeader.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        sectionHeader.isLayoutMarginsRelativeArrangement = true
        sectionHeader.rightButton.isHidden = true
        return sectionHeader
    }
    
    private func setUp() {
        navigationController?.navigationBar.isHidden = true
        moveToMailView.titleLabel.textColor = .g1000
        tableView.separatorStyle = .none
        tableView.register(InquiryTableViewCell.self,
                           forCellReuseIdentifier: InquiryTableViewCell.reuseIdentifier)
    }
    
    private func setUpConstraint() {
        view.addSubview(headerView)
        view.addSubview(topSpaceView)
        view.addSubview(tableView)
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        topSpaceView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(Constants.spaceGuide.small300)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(self.createHeader(title: "직접 문의하기"))
        stackView.addArrangedSubview(moveToMailView)
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topSpaceView.snp.bottom)
            make.bottom.equalTo(stackView.snp.top)
            make.leading.trailing.equalToSuperview()
        }
    }
}
