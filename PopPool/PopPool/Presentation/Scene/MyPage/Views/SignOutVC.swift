//
//  SignOutVC.swift
//  PopPool
//
//  Created by Porori on 7/18/24.
//

import UIKit
import SnapKit
import RxSwift

final class SignOutVC: UIViewController {
    
    // MARK: - Components
    
    private var headerView: HeaderViewCPNT
    private let signOutView: SignOutSurveyView
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    init() {
        self.headerView = HeaderViewCPNT(title: "회원탈퇴", style: .icon(UIImage(systemName: "lasso")))
        self.signOutView = SignOutSurveyView()
        super.init(nibName: nil, bundle: nil)
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
        view.backgroundColor = .systemBackground
        self.headerView.rightBarButton.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setUpConstraints() {
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
    
    func bind() {
        headerView.leftBarButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        signOutView.skipButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                print("화면 이동 필요")
            }
            .disposed(by: disposeBag)
        
        signOutView.confirmButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                print("다음 화면 이동")
                let vc = SignOutCompleteVC()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        guard let lastView = signOutView.surveyView.last else { return }
        lastView.isCheck
            .withUnretained(self)
            .subscribe { (owner, isChecked) in
                owner.signOutView.makeTextViewActive(isChecked)
            }
            .disposed(by: disposeBag)
    }
}
