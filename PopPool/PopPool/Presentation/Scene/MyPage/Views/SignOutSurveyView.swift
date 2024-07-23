//
//  SignOutSurveryView.swift
//  PopPool
//
//  Created by Porori on 7/18/24.
//

import UIKit
import SnapKit
import RxSwift

// MARK: - SurveyList

final class SignOutSurveyView: UIStackView {
    
    // MARK: - Components
    
    private let title: ContentTitleCPNT
    private let topSpaceView = UIView()
    private let buttonTopView = UIView()
    private let bottomSpaceView = UIView()
    
    lazy var surveyView = self.survey.map { return TermsViewCPNT(title: $0) }
    private let surveyStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    private let surveyTextView: DynamicTextViewCPNT
    private let textViewContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    let skipButton: ButtonCPNT
    let confirmButton: ButtonCPNT
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(skipButton)
        stack.addArrangedSubview(confirmButton)
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    private var survey: [String] = []
    let tappedValues: PublishSubject<[Int]> = .init()
    
    // MARK: - Initializer
    
    init(surveyDetails: [String]) {
        self.title = ContentTitleCPNT(title: "탈퇴하려는 이유가\n무엇인가요?",
                                      type: .title_sub_fp(
                                        subTitle: "알려주시는 내용을 참고해 더 나은 팝풀을\n만들어볼게요."))
        self.confirmButton = ButtonCPNT(type: .primary, title: "확인")
        self.skipButton = ButtonCPNT(type: .secondary, title: "건너뛰기")
        self.surveyTextView = DynamicTextViewCPNT(placeholder: "탈퇴 이유를 입력해주세요", textLimit: 500)
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

private extension SignOutSurveyView {
    func bind() {
        Observable.from(surveyView)
            .withUnretained(self)
            .enumerated()
            .subscribe { (owner, index) in
                
            }
            .disposed(by: disposeBag)
    }    
    
    /// 서베이 화면에 활용된 TermsViewCPNT의 아이콘을 숨김처리합니다
    /// - Parameter view: TermsViewCPNT를 받습니다
    func setIconsAsHidden(_ view: TermsViewCPNT) {
        view.iconImageView.isHidden = true
    }
    
    func setUp() {
        self.axis = .vertical
        self.title.subTitleLabel.numberOfLines = 0
        self.title.subTitleLabel.lineBreakMode = .byTruncatingTail
        self.title.subTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setUpConstraints() {
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
        
        surveyView.forEach { list in
            surveyStack.addArrangedSubview(list)
            self.setIconsAsHidden(list)
            list.snp.makeConstraints { make in
                make.height.equalTo(49)
            }
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
            make.height.equalTo(52)
        }
        
        bottomSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.medium400)
        }
    }
}
