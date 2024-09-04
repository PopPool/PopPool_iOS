//
//  SignOutCompleteVC.swift
//  PopPool
//
//  Created by Porori on 7/19/24.
//

import UIKit
import SnapKit
import RxSwift

final class SignOutCompleteVC: UIViewController {
    
    // MARK: - Components
    
    private var headerView: HeaderViewCPNT
    private let topSpaceView = UIView()
    private let signOutConfirmImage: UIImageView
    private let signOutNoticeLabel: ContentTitleCPNT
    private let confirmButton: ButtonCPNT
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .vertical
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.addArrangedSubview(topSpaceView)
        stack.addArrangedSubview(signOutConfirmImage)
        stack.addArrangedSubview(signOutNoticeLabel)
        return stack
    }()
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: SignOutCompleteVM
    
    // MARK: - Initializer
    
    init(viewModel: SignOutCompleteVM) {
        self.headerView = HeaderViewCPNT(title: "회원탈퇴", style: .icon(UIImage(systemName: "lasso")))
        self.signOutConfirmImage = UIImageView(image: UIImage(named: "check_fill_signUp"))
        self.signOutNoticeLabel = ContentTitleCPNT(
            title: "탈퇴 완료\n다음에 또 만나요",
            type: .title_sub_fp( subTitle: "고객님이 만족하실 수 있는\n팝풀이 되도록 앞으로 노력할게요 :)")
        )
        self.confirmButton = ButtonCPNT(type: .primary, title: "확인")
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
        bind()
    }
}

// MARK: - Private Methods

extension SignOutCompleteVC {
    private func bind() {
        let input = SignOutCompleteVM.Input(deleteUserTapped: confirmButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.returnToRoot
            .withUnretained(self)
            .subscribe{ (owner, _) in
                owner.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setUp() {
        headerView.isHidden = true
        view.backgroundColor = .systemBackground
        signOutNoticeLabel.titleLabel.textAlignment = .center
        signOutNoticeLabel.subTitleLabel.textAlignment = .center
        
        signOutNoticeLabel.subTitleLabel.numberOfLines = 0
        signOutNoticeLabel.subTitleLabel.lineBreakMode = .byTruncatingTail
        signOutNoticeLabel.subTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setUpConstraints() {
        view.addSubview(headerView)
        view.addSubview(stackView)
        view.addSubview(confirmButton)
        
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        topSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.medium300)
        }
        
        signOutConfirmImage.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        
        signOutNoticeLabel.snp.makeConstraints { make in
            make.height.equalTo(182)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(Constants.spaceGuide.medium400)
            make.height.equalTo(50)
        }
    }
}
