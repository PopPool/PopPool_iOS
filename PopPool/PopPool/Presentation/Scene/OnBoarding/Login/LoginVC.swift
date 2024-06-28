//
//  !_!_!_.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/20/24.
//

import Foundation
import UIKit

class LoginVC: UIViewController {
    
// MARK: - Properties
    let rightBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "둘러보기",
            style: .plain,
            target: self,
            action: #selector(buttonTapped)
        )
        button.tintColor = .g1000
        return button
    }()
    
    let logoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    let logoImageView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = .lightLogo
        logoView.contentMode = .scaleAspectFit
        return logoView
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = "간편하게 SNS 로그인하고\n팝풀 서비스를 이용해보세요"
        label.font = .KorFont(style: .bold, size: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    let inquiryButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인이 어려우신가요?", for: .normal)
        button.setTitleColor(.g1000, for: .normal)
        button.titleLabel?.font = .KorFont(style: .regular, size: 12)
        return button
    }()
    
    let kakaoSignInButton: ButtonCPNT = ButtonCPNT(type: .kakao, title: "카카오톡으로 로그인")
    let appleSignInButton: ButtonCPNT = ButtonCPNT(type: .apple, title: "Apple로 로그인")
    lazy var spacer28 = SpacingFactory.shared.createSpace(on: self.view, size: 28)
    lazy var spacer64 = SpacingFactory.shared.createSpace(on: self.view, size: 64)
    lazy var spacer156 = SpacingFactory.shared.createSpace(on: self.view, size: 156)
    
    private let viewModel = LoginVM()
    private var loginServiceChecker: Int = 0
    
    @objc func buttonTapped() {
        
    }
    
}


// MARK: - Life Cycle
extension LoginVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bind()
    }
}

// MARK: - Setup

extension LoginVC {
    private func setupLayout() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = rightBarButton
        
        view.addSubview(logoStackView)
        logoStackView.addArrangedSubview(spacer64)
        logoStackView.addArrangedSubview(logoImageView)
        logoStackView.addArrangedSubview(spacer28)
        logoStackView.addArrangedSubview(notificationLabel)
        logoStackView.addArrangedSubview(spacer156)
        
        logoStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(kakaoSignInButton)
        buttonStackView.addArrangedSubview(appleSignInButton)
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(logoStackView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(116)
        }
        
        view.addSubview(inquiryButton)
        inquiryButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(88)
            make.centerX.equalToSuperview()
        }
    }
    
    func bind() {
        let input = LoginVM.Input(
            tourButtonTapped: rightBarButton.rx.tap,
            kakaoLoginButtonTapped: kakaoSignInButton.rx.tap,
            appleLoginButtonTapped: appleSignInButton.rx.tap,
            inquryButtonTapped: inquiryButton.rx.tap
        )
        let output = viewModel.transform(input: input)
    }
}
