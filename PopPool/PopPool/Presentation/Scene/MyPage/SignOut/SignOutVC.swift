//
//  SignOutVC.swift
//  PopPool
//
//  Created by Porori on 7/18/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignOutVC: BaseViewController {
    
    // MARK: - Components
    
    private let headerView = HeaderViewCPNT(
        title: "회원탈퇴",
        style: .icon(
            UIImage(systemName: "lasso")))
    
    private lazy var headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(tableHeaderView)
        stack.addArrangedSubview(headerSpaceView)
        return stack
    }()
    
    private let tableHeaderView = ContentTitleCPNT(
        title: "탈퇴하려는 이유가\n무엇인가요?",
        type: .title_sub_fp(
            subTitle: "알려주시는 내용을 참고해 더 나은 팝풀을\n만들어볼게요."))
        
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.register(SignOutTableViewCell.self,
                           forCellReuseIdentifier: SignOutTableViewCell.identifier)
        return tableView
    }()
    
    let skipButton = ButtonCPNT(
        type: .secondary,
        title: "건너뛰기")
    let confirmButton = ButtonCPNT(
        type: .primary,
        title: "확인")
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(skipButton)
        stack.addArrangedSubview(confirmButton)
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let headerSpaceView = UIView()
    
    // MARK: - Properties
    
    private let viewModel: SignOutVM
    private let disposeBag = DisposeBag()
    private let cellTapSubject = PublishSubject<(Survey, SignOutTableViewCell.SignOutState)>()
    
    // MARK: - Initializer
    
    init(viewModel: SignOutVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SignOutVC {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
        bind()
    }
}

private extension SignOutVC {
    
    // MARK: - Method
    
    func setUp() {
        self.headerView.rightBarButton.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUpConstraints() {
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(Constants.spaceGuide.medium400)
            make.height.equalTo(52)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(buttonStack.snp.top)
        }
        
        tableView.tableHeaderView = self.headerStack
        headerStack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        headerStack.isLayoutMarginsRelativeArrangement = true
        headerStack.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 250)
        
        headerStack.snp.makeConstraints { make in
            make.width.equalTo(view.bounds.width)
        }
        
        headerSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.medium400)
        }
    }
    
    func bind() {
        let input = SignOutVM.Input(
            returnActionTapped: headerView.leftBarButton.rx.tap,
            skipActionTapped: skipButton.rx.tap,
            confirmActionTapped: confirmButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.returnToRoot
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.skipScreen
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                let vm = SignOutCompleteVM(survey: [])
                let vc = SignOutCompleteVC(viewModel: vm)
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.moveToNextScreen
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                let vm = SignOutCompleteVM(survey: owner.viewModel.selectedArray)
                let vc = SignOutCompleteVC(viewModel: vm)
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.surveylist
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (owner, data) in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension SignOutVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.survey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SignOutTableViewCell.identifier, for: indexPath) as? SignOutTableViewCell else { return UITableViewCell() }
        cell.configure(data: viewModel.survey[indexPath.row])
        cell.tapSubject
            .subscribe(onNext: { [weak self] survey, state in
                if state == .tapped {
                    self?.viewModel.selectedArray.append(survey)
                } else {
                    self?.viewModel.selectedArray.removeAll(where: { $0 == survey })
                }
            })
            .disposed(by: disposeBag)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
