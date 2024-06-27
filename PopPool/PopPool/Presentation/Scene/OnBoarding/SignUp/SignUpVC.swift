//
//  SignUpVC.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/23/24.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class SignUpVC: UIViewController {
    
    private let progressIndicator: ProgressIndicatorCPNT = ProgressIndicatorCPNT(totalStep: 4, startPoint: 1)
    
    // MARK: - ContentTitles
    private var contentTitleViews: [ContentTitleCPNT] = [
        ContentTitleCPNT(
            title: "서비스 이용을 위한\n약관을 확인해주세요",
            type: .title_fp
        ),
        ContentTitleCPNT(
            title: "팝풀에서 사용할\n별명을 설정해볼까요?",
            type: .title_sub_fp(subTitle: "이 단계를 건너뛰시면 자동으로 별명이 만들어져요.")
        ),
        ContentTitleCPNT(
            title: "$유저명$님에 대해\n조금 더 알려주시겠어요?",
            type: .title_fp
        )
    ]
    private let contentTitleStackView: UIStackView = UIStackView()
    
    // MARK: - ContentViews
    private let step1View = SignUpStep1View()
    private let step3View = SignUpStep3View()
    private let step4View = SignUpStep4View()
    lazy var contentViews = [
        step1View,
        UIView(),
        step3View,
        step4View
    ]
    private let contentStackView: UIStackView = UIStackView()
    
    // MARK: - Buttons
    private let step1_primaryButton: ButtonCPNT = {
        let button = ButtonCPNT(type: .primary, title: "확인", disabledTitle: "확인")
        button.isEnabled = false
        return button
    }()
    private let step2_primaryButton = ButtonCPNT(type: .primary, title: "확인", disabledTitle: "다음")
    private let step2_secondaryButton = ButtonCPNT(type: .secondary, title: "건너뛰기")
    lazy var step2_buttons: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.step2_secondaryButton, self.step2_primaryButton])
        view.spacing = 10
        view.distribution = .fillEqually
        return view
    }()
    private let step3_primaryButton: ButtonCPNT = {
        let button = ButtonCPNT(type: .primary, title: "다음", disabledTitle: "다음")
        button.isEnabled = false
        return button
    }()
    private let step3_secondaryButton = ButtonCPNT(type: .secondary, title: "건너뛰기")
    lazy var step3_buttons: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.step3_secondaryButton, self.step3_primaryButton])
        view.spacing = 10
        view.distribution = .fillEqually
        return view
    }()
    private let step4_primaryButton = ButtonCPNT(type: .primary, title: "다음", disabledTitle: "다음")
    private let step4_secondaryButton = ButtonCPNT(type: .secondary, title: "건너뛰기")
    lazy var step4_buttons: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.step4_secondaryButton, self.step4_primaryButton])
        view.spacing = 10
        view.distribution = .fillEqually
        return view
    }()
    lazy var bottomButtons = [
        step1_primaryButton,
        step2_buttons,
        step3_buttons,
        step4_buttons
        
    ]
    private let buttonStackView: UIStackView = UIStackView()
    
    // MARK: - Properties
    private let viewModel = SignUpVM()
    private let disposeBag = DisposeBag()
}

// MARK: - Life Cycle
extension SignUpVC {
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        setUpConstraints()
        bind()
    }
}
// MARK: - SetUp
private extension SignUpVC {
    
    /// UI 요소의 레이아웃 제약 설정
    func setUpConstraints() {
        contentTitleStackView.addArrangedSubview(contentTitleViews[0])
        contentStackView.addArrangedSubview(contentViews[0])
        buttonStackView.addArrangedSubview(bottomButtons[0])
        view.addSubview(progressIndicator)
        view.addSubview(contentTitleStackView)
        view.addSubview(contentStackView)
        view.addSubview(buttonStackView)
        
        progressIndicator.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Constants.spaceGuide._16px)
            make.leading.trailing.equalToSuperview().inset(Constants.spaceGuide._20px)
        }
        contentTitleStackView.snp.makeConstraints { make in
            make.top.equalTo(progressIndicator.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(Constants.spaceGuide._20px)
        }
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.spaceGuide._20px)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().inset(Constants.spaceGuide._48px)
        }
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(contentTitleStackView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(Constants.spaceGuide._20px)
            make.bottom.equalTo(buttonStackView.snp.top)
        }

    }
    
    /// ViewModel과의 바인딩을 설정
    func bind() {
        let input = SignUpVM.Input(
            tap_step1_primaryButton: step1_primaryButton.rx.tap,
            tap_step2_primaryButton: step2_primaryButton.rx.tap,
            tap_step3_primaryButton: step3_primaryButton.rx.tap,
            didChangeTerms: step1View.terms,
            didChangeInterestList: step3View.fetchSelectedList()
        )
        let output = viewModel.transform(input: input)
        
        // 페이지 인덱스 증가 이벤트 처리
        output.increasePageIndex
            .withUnretained(self)
            .subscribe { (owner, pageIndex) in
                owner.progressIndicator.increaseIndicator()
                owner.changeViewFrom(pageIndex: pageIndex, previousIndex: pageIndex - 1)
            }
            .disposed(by: disposeBag)
        
        // Step 1 primary button 활성/비활성 상태 처리
        output.step1_primaryButton_isEnabled
            .withUnretained(self)
            .subscribe { (owner, isEnabled) in
                owner.changeButtonState(button: owner.step1_primaryButton, isEnabled: isEnabled)
            }
            .disposed(by: disposeBag)
        
        // Step 3 primary button 활성/비활성 상태 처리
        output.step3_primaryButton_isEnabled
            .withUnretained(self)
            .subscribe { (owner, isEnabled) in
                owner.changeButtonState(button: owner.step3_primaryButton, isEnabled: isEnabled)
            }
            .disposed(by: disposeBag)
        
        // 카테고리 리스트 가져오기
        output.fetchCategoryList
            .withUnretained(self)
            .subscribe { (owner, list) in
                owner.step3View.setCategoryList(list: list)
            }
            .disposed(by: disposeBag)
    }
    
    /// 페이지 인덱스에 따라 뷰 변경을 처리하는 메서드
    ///
    /// - Parameters:
    ///   - pageIndex: 현재 페이지 인덱스
    ///   - previousIndex: 이전 페이지 인덱스
    func changeViewFrom(pageIndex: Int, previousIndex: Int) {
        if pageIndex < contentTitleViews.count {
            UIView.transition(with: contentTitleStackView, duration: 0.2, options: .transitionCrossDissolve) {
                self.contentTitleViews[previousIndex].removeFromSuperview()
                self.contentTitleStackView.addArrangedSubview(self.contentTitleViews[pageIndex])
            }
        }
        if pageIndex < contentViews.count {
            UIView.transition(with: contentStackView, duration: 0.2, options: .transitionCrossDissolve) {
                self.contentViews[previousIndex].removeFromSuperview()
                self.contentStackView.addArrangedSubview(self.contentViews[pageIndex])
            }
        }
        if pageIndex < bottomButtons.count {
            UIView.transition(with: buttonStackView, duration: 0.2, options: .transitionCrossDissolve) {
                self.bottomButtons[previousIndex].removeFromSuperview()
                self.buttonStackView.addArrangedSubview(self.bottomButtons[pageIndex])
            }
        }
    }
    
    /// 버튼의 활성/비활성 상태를 변경하는 메서드
    ///
    /// - Parameters:
    ///   - button: 대상 버튼
    ///   - isEnabled: 활성화 여부
    func changeButtonState(button: UIButton, isEnabled: Bool) {
        if button.isEnabled != isEnabled {
            UIView.transition(with: button, duration: 0.2, options: .transitionCrossDissolve) {
                button.isEnabled = isEnabled
            }
        }
    }
}
