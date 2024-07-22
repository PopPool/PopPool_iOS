//
//  TermsViewCPNT.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/25/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TermsViewCPNT: UIStackView {
    
    // MARK: - Components
    private let checkButton: UIButton = {
        let view = UIButton()
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 14)
        return label
    }()
    let iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "line_signUp")
        return view
    }()
    let termsButton: UIButton = {
        let button = UIButton()
        return button
    }()
    private let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    // MARK: - Properties
    /// 체크 상태를 나타내는 BehaviorRelay
    let isCheck: BehaviorRelay<Bool> = .init(value: false)
    private let disposeBag = DisposeBag()
    
    init(title: String) {
        super.init(frame: .zero)
        setUp()
        setUpConstraints()
        bind()
        titleLabel.text = title
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: - SetUp
private extension TermsViewCPNT {
    
    /// 뷰 설정
    func setUp() {
        self.alignment = .center
        self.spacing = 8
    }
    
    /// 제약 조건 설정
    func setUpConstraints() {
        checkButton.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(22)
        }
        buttonStackView.addArrangedSubview(titleLabel)
        buttonStackView.addArrangedSubview(iconImageView)
        termsButton.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.addArrangedSubview(checkButton)
        self.addArrangedSubview(termsButton)
    }
    
    /// 바인딩 설정
    func bind() {
        // 체크 버튼 탭 이벤트 처리
        checkButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.isCheck.accept(!owner.isCheck.value)
            }
            .disposed(by: disposeBag)
        
        // 체크 상태 변화에 따른 UI 업데이트 처리
        isCheck
            .withUnretained(self)
            .subscribe { (owner, isCheck) in
                let image = isCheck ? UIImage(named: "check_fill_signUp") : UIImage(named: "check_signUp")
                owner.checkButton.setImage(image, for: .normal)
            }
            .disposed(by: disposeBag)
    }
}
