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
    
    private let headerView = HeaderViewCPNT(title: "회원탈퇴", style: .icon(UIImage(systemName: "lasso")))
    private lazy var signOutView = SignOutSurveyView(surveyDetails: [])
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let contentStackView = UIStackView()
            
    // MARK: - Properties
    
    private let viewModel: SignOutVM
    private let disposeBag = DisposeBag()
    
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
        scrollView.showsVerticalScrollIndicator = false
        self.headerView.rightBarButton.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setUpConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.snp.width)
        }
        
        containerView.addSubview(headerView)
        containerView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(signOutView)
        
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(Constants.spaceGuide.small200)
            make.bottom.equalTo(containerView.snp.bottom)
        }
        
        scrollView.layoutIfNeeded()
        adjustBehavior()
    }
    
    func bind() {
        let input = SignOutVM.Input()
        let output = viewModel.transform(input: input)
        
        output.surveylist
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, list) in
                owner.signOutView.updateSurvey(list)
            })
            .disposed(by: disposeBag)
        
        headerView.leftBarButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        signOutView.tappedValues
            .withUnretained(self)
            .subscribe(onNext: { (owner, tapped) in
                
                if let last = owner.signOutView.surveyView.last {
                    last.isCheck
                        .subscribe { isChecked in
                            owner.signOutView.makeTextViewActive(isChecked)
                        }
                        .disposed(by: owner.disposeBag)
                }
            })
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
    }
    
    /// scrollView 높이가 contentview보다 낮을 경우 scrollable 기능 활성화 여부
    func adjustBehavior() {
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.bounds.height
        
        scrollView.isScrollEnabled = contentHeight > scrollViewHeight
    }
}
