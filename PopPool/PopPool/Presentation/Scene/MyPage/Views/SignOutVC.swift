//
//  SignOutVC.swift
//  PopPool
//
//  Created by Porori on 7/18/24.
//

import UIKit
import SnapKit
import RxSwift

class SignOutVC: UIViewController {
    
    private var headerView: HeaderViewCPNT
    private let signOutView: SignOutSurveyView
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    private let disposeBag = DisposeBag()
    
    init() {
        self.headerView = HeaderViewCPNT(title: "회원탈퇴", style: .icon(UIImage(systemName: "lasso")))
        self.signOutView = SignOutSurveyView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpLayout()
        bind()
    }
    
    private func setUp() {
        view.backgroundColor = .systemBackground
        self.headerView.rightBarButton.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setUpLayout() {
        view.addSubview(headerView)
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(signOutView)
        
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(Constants.spaceGuide.small200)
            make.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        headerView.leftBarButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
