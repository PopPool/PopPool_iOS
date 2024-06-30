//
//  LoginBottomSheet.swift
//  PopPool
//
//  Created by Porori on 6/30/24.
//

import UIKit
import RxSwift

class LoginBottomSheetVC: ModalViewController {
    
    lazy var topStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 32
        stack.axis = .vertical
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(infoBox)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.addArrangedSubview(loginButton)
        stack.addArrangedSubview(cancelButton)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var spacer36 = SpacingFactory.shared.createSpace(on: self.view, size: 36)
    lazy var loginButton = ButtonCPNT(type: .primary, title: "로그인")
    lazy var cancelButton = ButtonCPNT(type: .secondary, title: "취소")
    private let titleLabel = ContentTitleCPNT(
        title: "이미 등록된 계정이 있어요\n아래 계정으로 로그인할까요?",
        type: .title_bs(buttonImage: nil)
    )
    let infoBox = CMPTInfoBoxView()
    
    private let viewModel = LoginBottomSheetVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraint()
    }
    
    private func setUpConstraint() {
        // 버튼 높이 설정
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        
        // 스택 적용
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(infoBox)
        contentStack.addArrangedSubview(spacer36)
        contentStack.addArrangedSubview(buttonStack)
        self.setContent(content: contentStack)
    }
    
    private func bind() {
        let input = LoginBottomSheetVM.Input(
            loginButtonTapped: loginButton.rx.tap,
            cancelButtonTapped: cancelButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.pushToMainScreen
            .subscribe(
                onNext: { [weak self] in
                    print("메인 화면으로 넘어갑니다.")
                    // 메인 화면 구현 이후 추가
                },
                onError: { error in
                    print("오류가 발생했습니다")
                    print(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
        
        output.removeFromScreen
            .subscribe(
                onNext: { [weak self] in
                    print("화면에서 내려갑니다.")
                    self?.dismissBottomSheet()
                }, onError: { error in
                    print("오류가 발생했습니다")
                    print(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
}
