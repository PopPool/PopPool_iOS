//
//  DynamicTextViewCPNT.swift
//  PopPool
//
//  Created by Porori on 7/11/24.
//

import UIKit
import RxSwift
import SnapKit

final class DynamicTextViewCPNT: UIStackView {
    
    /// TF 상태값
    enum TextViewState {
        case none_active
        case normal_active(String)
        case overText_active(Int)
        case none
        case normal(String)
        case overText(Int)
        
        var stateColor: UIColor {
            switch self {
            case .none, .normal:
                return .g100
            case .normal_active, .none_active:
                return .g1000
            case .overText, .overText_active(_):
                return .re500
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .none, .none_active:
                return .g200
            case .normal, .normal_active:
                return .g1000
            case .overText, .overText_active:
                return .re500
            }
        }
        
        var description: String? {
            switch self {
            case .overText(let limit), .overText_active(let limit):
                return "최대 \(limit)자까지 입력해주세요"
            default:
                return nil
            }
        }
        
        var placeHolderIsHidden: Bool {
            switch self {
            case .none_active, .none:
                return false
            default:
                return true
            }
        }
    }
    
    //MARK: - Components
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 4
        view.layer.borderColor = UIColor.g100.cgColor
        view.layer.borderWidth = 1.2
        return view
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.KorFont(style: .regular, size: 12)
        return label
    }()
    
    let textView: UITextView = {
        let tf = UITextView()
        tf.isScrollEnabled = false
        tf.setContentHuggingPriority(.defaultHigh, for: .vertical)
        tf.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        tf.textContainerInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        return tf
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.KorFont(style: .regular, size: 12)
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.KorFont(style: .regular, size: 12)
        label.textColor = .g200
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
    
    //MARK: - Properties
    let textViewStateObserver: PublishSubject<TextViewState> = .init()
    private let textLimitCount: Int
    private let disposeBag = DisposeBag()
    private var isActive = false
    
    //MARK: - Initializer
    
    init(placeholder: String, textLimit: Int) {
        self.textLimitCount = textLimit
        super.init(frame: .zero)
        setUpConstraint()
        setUp(placeholder: placeholder)
        bind(placeholder: placeholder)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activate() {
        self.textView.becomeFirstResponder()
    }
    
    func deactivate() {
        self.textView.resignFirstResponder()
    }
}

// MARK: - SetUp
private extension DynamicTextViewCPNT {

    func setUp(placeholder: String) {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = UIColor.g200
    }
    
    func setUpConstraint() {
        self.addArrangedSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        textView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview()
            make.leading.equalToSuperview().inset(5)
        }
        
        bgView.addSubview(textView)
        textView.snp.makeConstraints { make in
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
    
    func bind(placeholder: String) {
        // 텍스트 입력 시 countLabel 변경
        textView.rx.text.orEmpty
            .withUnretained(self)
            .subscribe { (owner, text) in
                owner.setState(text: text, isActive: owner.isActive)
            }
            .disposed(by: disposeBag)
   
        textView.rx.didBeginEditing
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.isActive = true
                guard let text = owner.textView.text else { return }
                owner.setState(text: text, isActive: owner.isActive)
            }
            .disposed(by: disposeBag)

        textView.rx.didEndEditing
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.isActive = false
                guard let text = owner.textView.text else { return }
                owner.setState(text: text, isActive: owner.isActive)
            }
            .disposed(by: disposeBag)
        
        textViewStateObserver
            .withUnretained(self)
            .subscribe { (owner, state) in
                owner.changeView(from: state)
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - Methods
private extension DynamicTextViewCPNT {
    /// 상태에 따라 컴포넌트의 UI를 변경합니다
    /// - Parameter state: TextFieldstate 타입 - 상태 값을 받습니다
    func changeView(from: TextViewState) {
        textView.textColor = from.textColor
        bgView.layer.borderColor = from.stateColor.cgColor
        descriptionLabel.text = from.description
        descriptionLabel.textColor = from.textColor
        countLabel.textColor = from.textColor
        placeholderLabel.isHidden = from.placeHolderIsHidden
        countLabel.textColor = from.stateColor
    }
    
    /// 텍스트 필드의 최대 입력 범위를 걸어두는 메서드
    /// - Parameters:
    ///   - text: String 타입 - 현재 작성되고 있는 텍스트를 받습니다
    ///   - limit: Int 타입 -  작성할 수 있는 최대 글자 수를 받습니다
    func setTextLimit(text: String) {
        let count = text.count
        self.countLabel.text = "\(count) / \(textLimitCount)자"
    }
    
    /// 텍스트 필드의 상태 변화를 감지하기 위한 메서드
    /// - Parameters:
    ///   - text: String 타입 - 현재 작성되고 있는 텍스트를 받습니다
    ///   - textLimit: Int 타입 -  작성할 수 있는 최대 글자 수를 받습니다
    /// - Returns: 상황에 알맞는 상태값을 리턴합니다
    func setState(text: String, isActive: Bool) {
        var state: TextViewState
        if isActive {
            if text.count == 0 {
                state = .none_active
            } else if text.count > textLimitCount {
                state = .overText_active(textLimitCount)
            } else {
                state = .normal_active(text)
            }
        } else {
            if text.count == 0 {
                state = .none
            } else if text.count > textLimitCount {
                state = .overText(textLimitCount)
            } else {
                state = .normal(text)
            }
        }
        textViewStateObserver.onNext(state)
        setTextLimit(text: text)
    }
}
