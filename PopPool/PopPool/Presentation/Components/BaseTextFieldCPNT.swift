//
//  BaseTextFieldCPNT.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BaseTextFieldCPNT: UIStackView {
    
    let textFieldBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.borderColor = UIColor.g100.cgColor
        view.layer.borderWidth = 1.2
        view.layer.cornerRadius = 4
        return view
    }()
    
    let textFieldStackView: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    let textField: UITextField = {
        let view = UITextField()
        view.font = .KorFont(style: .medium, size: 14)
        view.textColor = UIColor.g1000
        return view
    }()
    
    let clearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancel_signUp"), for: .normal)
        return button
    }()
    
    let bottomStackView: UIStackView = {
        let view = UIStackView()
        view.layoutMargins = .init(top: 0, left: 4, bottom: 0, right: 4)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 12)
        label.textColor = UIColor.g500
        return label
    }()
    
    let textCountLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 12)
        label.textAlignment = .right
        label.textColor = UIColor.g500
        return label
    }()
    
    // MARK: - Properties
    
    let limitTextCount: Int
    
    let disposeBag = DisposeBag()
    
    // MARK: - init
    
    init(isEnable: Bool = true, placeHolder: String?, description: String? = nil, limitTextCount: Int? = nil) {
        if let limitTextCount = limitTextCount {
            self.limitTextCount = limitTextCount
        } else {
            self.limitTextCount = 0
        }
        super.init(frame: .zero)
        setUp(isEnable: isEnable, placeHolder: placeHolder, description: description, limitTextCount: limitTextCount)
        setUpConstraints(description: description, limitTextCount: limitTextCount)
        bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp

private extension BaseTextFieldCPNT {
    func setUp(isEnable: Bool, placeHolder: String?, description: String?, limitTextCount: Int?) {
        self.axis = .vertical
        self.spacing = 6
        
        textField.placeholder = placeHolder
        descriptionLabel.text = description
        textCountLabel.text = "0 / \(self.limitTextCount)자"
        
        if !isEnable {
            self.isUserInteractionEnabled = false
            self.textFieldBackGroundView.backgroundColor = .pb4
        }
    }
    
    func setUpConstraints(description: String?, limitTextCount: Int?) {
        clearButton.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        textField.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        textFieldBackGroundView.addSubview(textFieldStackView)
        textFieldStackView.addArrangedSubview(textField)
        textFieldStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(15)
        }
        
        if let _ = description {
            bottomStackView.addArrangedSubview(descriptionLabel)
        }
        
        if let _ = limitTextCount {
            bottomStackView.addArrangedSubview(textCountLabel)
        }
        self.addArrangedSubview(textFieldBackGroundView)
        if description != nil || limitTextCount != nil {
            self.addArrangedSubview(bottomStackView)
        }
    }
    
    func bind() {
        textField.rx.controlEvent(.editingDidBegin)
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.textFieldBackGroundView.layer.borderColor = UIColor.g1000.cgColor
                owner.textFieldStackView.addArrangedSubview(owner.clearButton)
            }
            .disposed(by: disposeBag)
        
        textField.rx.text
            .orEmpty
            .withUnretained(self)
            .subscribe { (owner, text) in
                owner.textCountLabel.text = "\(text.count) / \(owner.limitTextCount)자"
            }
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidEnd)
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.textFieldBackGroundView.layer.borderColor = UIColor.g100.cgColor
                owner.clearButton.removeFromSuperview()
            }
            .disposed(by: disposeBag)
    }
}
