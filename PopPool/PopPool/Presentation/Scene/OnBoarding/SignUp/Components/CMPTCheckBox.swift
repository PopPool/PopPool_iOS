//
//  CMPTCheckBox.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/25/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CMPTCheckBox: UIButton {
    
    // MARK: - Components
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .bold, size: 15)
        return label
    }()
    private let checkImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "checkBox_disabled_signUp")
        view.tintColor = .blue
        return view
    }()
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 8
        view.isUserInteractionEnabled = false
        view.alignment = .center
        return view
    }()
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    /// 체크 상태를 나타내는 BehaviorRelay
    var isCheck: BehaviorRelay<Bool> = .init(value: false)

    init(title: String) {
        super.init(frame: .zero)
        contentLabel.text = title
        setUp()
        setUpConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension CMPTCheckBox {
    
    /// 뷰 설정
    func setUp() {
        self.backgroundColor = .g50
        self.layer.cornerRadius = 4
    }
    
    /// 제약 조건 설정
    func setUpConstraints() {
        checkImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        contentLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        stackView.addArrangedSubview(checkImageView)
        stackView.addArrangedSubview(contentLabel)
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(SpaceGuide._20px)
            make.top.bottom.equalToSuperview().inset(SpaceGuide._12px)
        }
    }
    
    /// 바인딩 설정
    func bind() {
        // 버튼 탭 이벤트 처리
        self.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.isCheck.accept(!owner.isCheck.value)
            }
            .disposed(by: disposeBag)
        
        // 체크 상태 변화에 따른 UI 업데이트 처리
        self.isCheck
            .withUnretained(self)
            .subscribe { (owner, isCheck) in
                owner.checkImageView.image = isCheck ? UIImage(named: "checkBox_activated_signUp") : UIImage(named: "checkBox_disabled_signUp")
            }
            .disposed(by: disposeBag)
    }
}
