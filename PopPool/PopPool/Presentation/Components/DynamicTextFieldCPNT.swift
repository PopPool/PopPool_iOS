//
//  DynamicTextFieldCPNT.swift
//  PopPool
//
//  Created by Porori on 7/11/24.
//

import UIKit
import RxSwift
import SnapKit

final class DynamicTextFieldCPNT: UIStackView {
    
    enum TextFieldstate {
        case none
        case typing
        case overText(Int)
        
        var borderColor: UIColor {
            switch self {
            case .none:
                return UIColor.g200
            case .typing:
                return UIColor.g1000
            case .overText:
                return UIColor.re500
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .none:
                return UIColor.g200
            case .typing:
                return UIColor.g1000
            case .overText:
                return UIColor.re500
            }
        }
        
        var description: String? {
            switch self {
            case .overText(let limit):
                return "최대 \(limit)자까지 입력해주세요"
            default:
                return nil
            }
        }
    }
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 4
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.2
        return view
    }()
    
    private let textField: UITextView = {
        let tf = UITextView()
        tf.isScrollEnabled = false
        tf.setContentHuggingPriority(.defaultHigh, for: .vertical)
        tf.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return tf
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "테스팅"
        label.font = UIFont.KorFont(style: .regular, size: 12)
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "테스팅"
        label.textAlignment = .right
        label.font = UIFont.KorFont(style: .regular, size: 12)
        return label
    }()
    
    private lazy var bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(countLabel)
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    
    let disposeBag = DisposeBag()
    
    init(placeholder: String, textLimit: Int) {
        super.init(frame: .zero)
        setupLayout()
        setup(placeholder: placeholder)
        bind(placeholder: placeholder, limit: textLimit)
    }
    
    private func bind(placeholder: String, limit: Int) {
        // 텍스트 입력 시 countLabel 변경
        textField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe { (owner, text) in
                let state = owner.fetchState(text: text, textLimit: limit)
                print("현 상태", state)
                owner.updateUI(state: state)
                owner.setTextLimit(text: text, limit: limit)
            }
            .disposed(by: disposeBag)
        
        textField.rx.didBeginEditing
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.bgView.layer.borderColor = UIColor.g1000.cgColor
            }
            .disposed(by: disposeBag)
        
        textField.rx.didEndEditing
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.bgView.layer.borderColor = UIColor.g200.cgColor
                
                if let text = owner.textField.text, text.isEmpty {
                    owner.textField.textColor = UIColor.g200
                    owner.textField.text = placeholder
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setup(placeholder: String) {
        textField.text = placeholder
        textField.textColor = UIColor.g200
    }
    
    private func setTextLimit(text: String, limit: Int) {
        let count = text.count
        self.countLabel.text = "\(count) / \(limit)자"
    }
    
    private func fetchState(text: String, textLimit: Int) -> TextFieldstate {
        if text.count == 0 {
            return .none
        } else if text.count > textLimit {
            return .overText(textLimit)
        }
        return .typing
    }
    
    private func updateUI(state: TextFieldstate) {
        textField.textColor = state.textColor
        bgView.layer.borderColor = state.borderColor.cgColor
        descriptionLabel.text = state.description
        descriptionLabel.textColor = state.textColor
        countLabel.textColor = state.textColor
    }
    
    private func setupLayout() {
        self.addArrangedSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        bgView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(88)
            make.bottom.equalToSuperview().inset(32)
        }
        
        bgView.addSubview(bottomStack)
        bottomStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(bgView.snp.bottom).inset(16)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
