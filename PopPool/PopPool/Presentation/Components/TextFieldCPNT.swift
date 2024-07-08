////
////  TextFieldCPNT.swift
////  PopPool
////
////  Created by Porori on 7/7/24.
////
//
//import UIKit
//import SnapKit
//import RxSwift
//import RxRelay
//import RxCocoa
//
//class TextFieldCPNT: BaseTextFieldCPNT {
//    
//    // 전반적인 데이터 변경에 대한 색상 담당
//    enum ValidationState {
//        case isValid
//        case isOver
//        case none
//        
//        var descriptionColor: UIColor {
//            switch self {
//            case .isOver: return UIColor.red
//            case .isValid, .none: return UIColor.black
//            }
//        }
//    }
//    
//    // 전반적인 데이터 변경에 대한 실질적인 값 변경
//    enum ContentType {
//        case nickname
//        case social
//        case email(SocialTYPE)
//
//        var placeholder: String {
//            switch self {
//            case .email:
//                return "이메일 주소를 입력해주세요"
//            case .nickname:
//                return "별명을 입력해주세요"
//            case .social:
//                return "인스타그램 ID를 입력해주세요"
//            }
//        }
//        
//        var description: String {
//            switch self {
//            case .email(let email):
//                if email.rawValue == "apple" {
//                    return "애플에 연동된 이메일 주소입니다"
//                } else {
//                    return "카카오에 연동된 이메일 주소입니다"
//                }
//            case .nickname:
//                return "사용중인 별명이에요"
//            case .social:
//                return "인스타그램 코멘트와 마이페이지에 ID가 노출됩니다"
//            }
//        }
//    }
//    
//    private lazy var checkValidationStack: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.addArrangedSubview(checkValidationButton)
//        stack.addArrangedSubview(checkValidationLine)
//        return stack
//    }()
//    
//    private let checkValidationButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("중복체크", for: .normal)
//        button.titleLabel?.font = .KorFont(style: .regular, size: 13)
//        button.setTitleColor(.g1000, for: .normal)
//        return button
//    }()
//    
//    private let checkValidationLine: UIView = {
//        let line = UIView()
//        line.layer.borderColor = UIColor.g300.cgColor
//        line.layer.borderWidth = 1
//        return line
//    }()
//    
//    private let disposeBag = DisposeBag()
//    let validationType: BehaviorRelay<ValidationState> = .init(value: .none)
//    
//    init(type: ContentType, content: String) {
//        super.init()
//        setUp()
//        bind()
//        
//        switch type {
//        case .email:
//            containerView.backgroundColor = UIColor.g200
//            textField.textColor = UIColor.g300
//            textField.isUserInteractionEnabled = false
//            cancelButton.isHidden = true
//            textCountLabel.isHidden = true
//            checkValidationStack.isHidden = true
//            
//            descriptionLabel.text = type.description
//            textField.placeholder = type.placeholder
//            textField.text = content
//            
//        case .nickname:
//            textField.placeholder = type.placeholder
//            descriptionLabel.text = type.description
//            
//        case .social:
//            textCountLabel.isHidden = true
//            textField.placeholder = type.placeholder
//            descriptionLabel.text = type.description
//        }
//    }
//    
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setUp() {
//        textFieldStackView.addArrangedSubview(checkValidationStack)
//        checkValidationLine.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(1)
//        }
//    }
//    
//    private func bind() {
//        textField.rx.text.orEmpty
//            .withUnretained(self)
//            .subscribe { (owner, value) in
//                owner.updateDescription(text: value)
//            }
//            .disposed(by: disposeBag)
//        
//        cancelButton.rx.tap
//            .withUnretained(self)
//            .subscribe { (owner, _) in
//                owner.textField.text = ""
//                owner.descriptionLabel.text = "변경됨"
//            }
//            .disposed(by: disposeBag)
//        
//        validationType
//            .withUnretained(self)
//            .subscribe { (owner, state) in
//                if state == .isOver {
//                    self.changeView(value: state)
//                } else {
//                    self.changeView(state: state)
//                }
//            }
//            .disposed(by: disposeBag)
//    }
//    
//    private func isTextCountValid(content: String) {
//        let count = content.count
//        
//        if count < 0 {
//            validationType.accept(.none)
//        } else if count <= 10 {
//            validationType.accept(.isValid)
//        } else {
//            validationType.accept(.isOver)
//        }
//    }
//    
//    private func updateDescription(text: String) {
//        let count = text.count
//        self.descriptionLabel.text = text
//        self.textCountLabel.text = "\(count)/10자"
//    }
//    
//    func changeView(value: ContentType) {
//        self.descriptionLabel.text = value.description
//    }
//}
