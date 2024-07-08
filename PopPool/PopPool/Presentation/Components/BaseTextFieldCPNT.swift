//
//  BaseTextFieldCPNT.swift
//  PopPool
//
//  Created by Porori on 7/7/24.
//

import UIKit
import SnapKit
import RxSwift

class BaseTextFieldCPNT: UIStackView {
    
    // MARK: - Components
    
    /// 전체 뷰
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.w100
        view.layer.borderColor = UIColor.g100.cgColor
        view.layer.borderWidth = 1.2
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    /// textfield + 버튼 stack
    let textFieldStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        return view
    }()
    
    /// textfield 자체
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "기본 값"
        textField.font = .KorFont(style: .medium, size: 14)
        return textField
    }()
    
    /// 텍스트 필드에서의 삭제 버튼
    let cancelButton: UIButton = {
        let button = UIButton()
        let backgroudImage = UIImage(named: "cancel_signUp")
        button.setBackgroundImage(backgroudImage, for: .normal)
        button.setBackgroundImage(backgroudImage, for: .highlighted)
        return button
    }()
    
    /// valdiationLabel + 0/0자
    let validationStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.directionalLayoutMargins = .init(top: 0, leading: 4, bottom: 0, trailing: 4)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    /// 문제가 있을 때 하단에 등장하는 validationLabel
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 12)
        label.text = "기본 값"
        return label
    }()
    
    /// 0/0자
    let textCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .KorFont(style: .regular, size: 12)
        label.textColor = .g500
        label.text = "기본 값"
        return label
    }()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    // init 단계에서 인자를 받는다?
    init() {
        super.init(frame: .zero)
        setAutoLayout()
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseTextFieldCPNT {
    
    // MARK: - Methods
    
    private func setAutoLayout() {
        self.spacing = 6
        self.axis = .vertical
        
        setUpContainerView()
        setUpTextfield()
        setUpDescriptionLabels()
    }
    
    private func setUpContainerView() {
        addArrangedSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
    }
    
    private func setUpTextfield() {
        containerView.addSubview(textFieldStackView)
        textFieldStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(15)
        }
        
        textFieldStackView.addArrangedSubview(textField)
        textFieldStackView.addArrangedSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(21)
        }
    }
    
    private func setUpDescriptionLabels() {
        validationStackView.addArrangedSubview(descriptionLabel)
        validationStackView.addArrangedSubview(textCountLabel)
        self.addArrangedSubview(validationStackView)
    }
}
