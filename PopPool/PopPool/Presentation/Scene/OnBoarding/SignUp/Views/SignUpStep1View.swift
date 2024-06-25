//
//  SignUpStep1View.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/25/24.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

final class SignUpStep1View: UIStackView {
    
    // MARK: - Components
    private let topSpacingView = UIView()
    private let middleSpacingView = UIView()
    private let checkBox = CMPTCheckBox(title: "약관에 모두 동의할게요")
    private let term1View = CMPTTermsView(title: "[필수] 이용약관")
    private let term2View = CMPTTermsView(title: "[필수] 개인정보 수집 및 이용")
    private let term3View = CMPTTermsView(title: "[필수] 만 14세 이상")
    private let term4View = CMPTTermsView(title: "[선택] 광고성 정보 수신")
    private let termsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    /// 약관 동의 상태를 전달하는 PublishSubject
    var terms: PublishSubject<[Bool]> = .init()
    
    init() {
        super.init(frame: .zero)
        setUp()
        setUpConstraints()
        bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension SignUpStep1View {
    
    /// 뷰 설정
    func setUp() {
        self.axis = .vertical
    }
    
    /// 제약 조건 설정
    func setUpConstraints() {
        topSpacingView.snp.makeConstraints { make in
            make.height.equalTo(SpaceGuide._48px)
        }
        middleSpacingView.snp.makeConstraints { make in
            make.height.equalTo(SpaceGuide._36px)
        }
        termsStackView.addArrangedSubview(term1View)
        termsStackView.addArrangedSubview(term2View)
        termsStackView.addArrangedSubview(term3View)
        termsStackView.addArrangedSubview(term4View)
        self.addArrangedSubview(topSpacingView)
        self.addArrangedSubview(checkBox)
        self.addArrangedSubview(middleSpacingView)
        self.addArrangedSubview(termsStackView)
    }
    
    /// 바인딩 설정
    func bind() {
        let termViews = [term1View, term2View, term3View, term4View]
        
        // 체크박스 탭 이벤트 처리
        checkBox.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                let isCheck = owner.checkBox.isCheck.value
                termViews.forEach { term in
                    term.isCheck.accept(isCheck)
                }
            }
            .disposed(by: disposeBag)
        
        // 각 약관 동의 상태 변경 시 처리
        Observable.combineLatest(termViews.map{$0.isCheck})
            .withUnretained(self)
            .subscribe(onNext: { owner, isChecks in
                owner.terms.onNext(isChecks)
                let isAllCheck = isChecks.allSatisfy { $0 }
                owner.checkBox.isCheck.accept(isAllCheck)
            })
            .disposed(by: disposeBag)
    }
}
