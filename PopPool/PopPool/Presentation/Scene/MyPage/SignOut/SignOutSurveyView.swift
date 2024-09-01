//
//  SignOutSurveryView.swift
//  PopPool
//
//  Created by Porori on 7/18/24.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

// MARK: - SurveyList

final class SignOutSurveyView: UIStackView {
    
    // MARK: - Components
    
    private let title = ContentTitleCPNT(
        title: "탈퇴하려는 이유가\n무엇인가요?",
        type: .title_sub_fp(
            subTitle: "알려주시는 내용을 참고해 더 나은 팝풀을\n만들어볼게요."))
    private let topSpaceView = UIView()
    private let buttonTopView = UIView()
    private let bottomSpaceView = UIView()
    
    var surveyView: [TermsViewCPNT] = []
    private let surveyStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    private let surveyTextView = DynamicTextViewCPNT(
        placeholder: "탈퇴 이유를 입력해주세요",
        textLimit: 500)
    private let textViewContainer: UIView = {
        let view = UIView()
        return view
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
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private var survey: [String] = []
    private var result: [Int] = []
    let tappedValues: BehaviorRelay<[Int]> = .init(value: [])
    
    // MARK: - Initializer
    
    init(surveyDetails: [String]) {
        self.survey = surveyDetails
        super.init(frame: .zero)
        setUp()
        setUpConstraints()
        bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Method
    
    /// 텍스트뷰의 visibility를 설정합니다
    /// - Parameter isChecked: check 버튼의 눌림 여부를 파악합니다
    func makeTextViewActive(_ isChecked: Bool) {
        self.surveyTextView.isHidden = !isChecked
        isChecked ? self.surveyTextView.activate() : self.surveyTextView.deactivate()
    }
}

    // MARK: - Private Methods

extension SignOutSurveyView {
    private func bind() {
        surveyView.enumerated().forEach { index, list in
            list.isCheck
                .distinctUntilChanged()
                .withUnretained(self)
                .subscribe(onNext: { (owner, tapped) in
                    if tapped {
                        owner.result.append(index)
                    } else {
                        if let removeIndex = owner.result.firstIndex(of: index) {
                            owner.result.remove(at: removeIndex)
                        }
                    }
                    owner.tappedValues.accept(owner.result)
                })
                .disposed(by: disposeBag)
            }
    }
    
    /// API 호출 받은 서베이 데이터를 화면에 그립니다.
    /// - Parameter surveys: 서베이 데이터를 받기 위한 String 타입의 배열
    public func updateSurvey(_ surveys: [String]) {
        surveyView = surveys.map { TermsViewCPNT(title: $0) }
        
        surveyView.forEach { view in
            surveyStack.addArrangedSubview(view)
            setIconsAsHidden(view)
            view.snp.makeConstraints { make in
                make.height.equalTo(49)
            }
        }
        
        // 데이터를 더한 이후 화면을 다시 호출합니다.
        setNeedsLayout()
        layoutIfNeeded()
        
        bind()
    }
    
    /// 서베이 화면에 활용된 TermsViewCPNT의 아이콘을 숨김처리합니다
    /// - Parameter view: TermsViewCPNT를 받습니다
    private func setIconsAsHidden(_ view: TermsViewCPNT) {
        view.iconImageView.isHidden = true
    }
    
    private func setUp() {
        self.axis = .vertical
        self.title.subTitleLabel.numberOfLines = 0
        self.title.subTitleLabel.lineBreakMode = .byTruncatingTail
        self.title.subTitleLabel.adjustsFontSizeToFitWidth = true
        self.surveyTextView.textView.isScrollEnabled = true
    }
    
    private func setUpConstraints() {
        self.addArrangedSubview(title)
        self.addArrangedSubview(topSpaceView)
        self.addArrangedSubview(surveyStack)
        self.addArrangedSubview(textViewContainer)
        self.addArrangedSubview(buttonTopView)
        self.addArrangedSubview(buttonStack)
        self.addArrangedSubview(bottomSpaceView)
        
        title.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        topSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.medium400)
        }
        
        surveyStack.snp.makeConstraints { make in
            make.top.equalTo(topSpaceView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        textViewContainer.addSubview(surveyTextView)
        textViewContainer.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(80)
        }
        
        surveyTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(26)
            make.top.bottom.trailing.equalToSuperview()
        }
        
        buttonTopView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualToSuperview().priority(.low)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(textViewContainer.snp.bottom).offset(10)
            make.height.equalTo(52)
        }
        
        bottomSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.medium400)
        }
    }
}
