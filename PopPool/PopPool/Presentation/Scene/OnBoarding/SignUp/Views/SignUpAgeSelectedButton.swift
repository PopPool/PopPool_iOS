//
//  SignUpAgeSelectedButton.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/28/24.
//

import UIKit
import SnapKit

final class SignUpAgeSelectedButton: UIButton {
    
    // MARK: - Components
    private let defaultLabel: UILabel = {
        let label = UILabel()
        label.text = "나이를 선택해주세요"
        label.font = .KorFont(style: .medium, size: 14)
        label.textColor = .g400
        return label
    }()
    private let rightIconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bottomArrow_signUp")
        return view
    }()
    private let superStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        view.alignment = .center
        view.isUserInteractionEnabled = false
        return view
    }()
    private let verticalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        view.isUserInteractionEnabled = false
        return view
    }()
    private let ageTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .medium, size: 11)
        label.textColor = .g400
        label.text = "나이"
        return label
    }()
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .medium, size: 14)
        label.textColor = .g1000
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension SignUpAgeSelectedButton {
    
    //기본 설정
    func setUp() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.g200.cgColor
    }
    
    //뷰 제약 설정
    func setUpConstraints() {

        self.addSubview(superStackView)
        
        superStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        rightIconView.snp.makeConstraints { make in
            make.size.equalTo(22)
        }

        superStackView.addArrangedSubview(defaultLabel)
        superStackView.addArrangedSubview(rightIconView)
    }
}

extension SignUpAgeSelectedButton {
    
    /// ageLabel의 text를 설정하며 화면을 변화하는 기능
    /// - Parameter age: 나이
    func setAge(age: Int) {
        ageLabel.text = "\(age)세"
        defaultLabel.removeFromSuperview()
        rightIconView.removeFromSuperview()
        verticalStackView.addArrangedSubview(ageTitleLabel)
        verticalStackView.addArrangedSubview(ageLabel)
        superStackView.addArrangedSubview(verticalStackView)
        superStackView.addArrangedSubview(rightIconView)
    }
}
