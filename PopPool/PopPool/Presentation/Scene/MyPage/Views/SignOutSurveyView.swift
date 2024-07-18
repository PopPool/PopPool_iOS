//
//  SignOutSurveryView.swift
//  PopPool
//
//  Created by Porori on 7/18/24.
//

import UIKit
import SnapKit
import RxSwift

struct SurveyList {
    var title: String
}

class SignOutSurveyView: UIStackView {
    
    private let title: ContentTitleCPNT
    private let topSpaceView = UIView()
    private lazy var surveyView = self.survey.map { reason in
        return TermsViewCPNT(title: reason.title)
    }
    
    private let surveyStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.layoutMargins = UIEdgeInsets(top: 13, left: 0, bottom: 12, right: 0)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private let skipButton: ButtonCPNT
    private let confirmButton: ButtonCPNT
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(skipButton)
        stack.addArrangedSubview(confirmButton)
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let buttonTopView = UIView()
    private let bottomSpaceView = UIView()
    
    
    private let survey: [SurveyList] = [
        SurveyList(title: "원하는 팝업에 대한 정보가 없어요"),
        SurveyList(title: "팝업 정보가 적어요"),
        SurveyList(title: "이용빈도가 낮아요"),
        SurveyList(title: "다시 가입하고 싶어요"),
        SurveyList(title: "앱에 오류가 많이 생겨요"),
        SurveyList(title: "기타")
    ]
    
    init() {
        self.title = ContentTitleCPNT(title: "탈퇴하려는 이유가\n무엇인가요?",
                                      type: .title_sub_fp(
                                        subTitle: "알려주시는 내용을 참고해 더 나은 팝풀을\n만들어볼게요."))
        self.confirmButton = ButtonCPNT(type: .primary, title: "확인")
        self.skipButton = ButtonCPNT(type: .secondary, title: "건너뛰기")
        super.init(frame: .zero)
        setUp()
        setUpLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        self.axis = .vertical
    }
    
    private func setUpLayout() {
        self.addArrangedSubview(title)
        self.addArrangedSubview(topSpaceView)
        self.addArrangedSubview(surveyStack)
        self.addArrangedSubview(buttonTopView)
        self.addArrangedSubview(buttonStack)
        self.addArrangedSubview(bottomSpaceView)
        
        title.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(182)
        }
        
        topSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.medium400)
        }
        
        surveyView.forEach { list in
            surveyStack.addArrangedSubview(list)
            list.snp.makeConstraints { make in
                make.height.equalTo(49)
            }
        }
        
        surveyStack.snp.makeConstraints { make in
            make.top.equalTo(topSpaceView.snp.bottom)
            make.leading.trailing.equalToSuperview()
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
