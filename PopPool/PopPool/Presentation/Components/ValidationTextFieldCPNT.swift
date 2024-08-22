//
//  ValidationTextFieldCPNT.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ValidationTextFieldCPNT: BaseTextFieldCPNT {
    
    enum ValidationType {
        case nickName
    }
    
    /// 입력 상태를 정리하기 위한 enum입니다
    /// 텍스트필드별 추가되는 상태를 적용해주세요
    enum ValidationState {
        case none
        case activeNone
        case requestKorOrEn
        case requestButtonTap(String)
        case activeRequestButtonTap
        case overText(Int)
        case activeOverText(Int)
        case shortText
        case activeShortText
        case buttonTapError
        case valid(String)
        case myNickName
        case myNickNameActive
    }
    
    struct ValidationOutPut {
        var type: ValidationType
        var state: ValidationState
        
        var description: String? {
            switch state {
            case .myNickName, .myNickNameActive:
                return "사용중인 별명이에요"
            case .none, .activeNone:
                return nil
            case .requestKorOrEn:
                return "한글, 영문으로만 입력해주세요"
            case .requestButtonTap, .activeRequestButtonTap:
                return "중복체크를 진행해주세요"
            case .overText(let textLimit), .activeOverText(let textLimit):
                return "\(textLimit)글자까지만 입력할 수 있어요"
            case .shortText, .activeShortText:
                return "2글자 이상 입력해주세요"
            case .buttonTapError:
                return "이미 사용되고 있는 별명이에요"
            case .valid:
                return "사용 가능한 별명이에요"
            }
        }
        
        /// 텍스트필드를 감싸는 view의 컬러값
        var borderColor: UIColor {
            switch state {
            case .overText, .buttonTapError, .shortText, .requestKorOrEn, .activeOverText, .activeShortText:
                return UIColor.re500
            case .none, .myNickName, .valid:
                return UIColor.g100
            case .activeNone, .requestButtonTap, .activeRequestButtonTap, .myNickNameActive:
                return UIColor.g1000
            }
        }
        
        /// 텍스트필드 하단의 획의 count 컬러값
        var countLabelColor: UIColor {
            switch state {
            case .overText, .activeOverText(_), .activeShortText, .shortText:
                return UIColor.re500
            default:
                return UIColor.g500
            }
        }
        
        /// 텍스트필드 하단의 각 설명의 컬러값
        var descriptionColor: UIColor {
            switch state {
            case .overText, .buttonTapError, .shortText, .requestKorOrEn, .activeOverText, .activeShortText:
                return UIColor.re500
            case .none, .activeNone, .requestButtonTap, .activeRequestButtonTap, .myNickName, .myNickNameActive:
                return UIColor.g500
            case .valid:
                return UIColor.blu500
            }
        }
        
        /// state별로 x 버튼의 출력 여부
        var isClearButtonHidden: Bool {
            switch state {
            case .none, .activeNone, .requestButtonTap, .overText, .myNickName, .valid:
                return true
            default:
                return false
            }
        }
        
        /// state별로 '중복체크' 버튼의 출력 여부
        var isDuplicateCheckButtonHidden: Bool {
            switch state {
            case .requestButtonTap, .overText, .myNickName, .valid:
                return false
            default:
                return true
            }
        }
        
        var buttonColor: UIColor? {
            switch state {
            case .overText, .valid, .shortText, .buttonTapError, .myNickName, .myNickNameActive:
                return .g200
            default:
                return .g1000
            }
        }
        
        var isButtonEnabled: Bool {
            switch state {
            case .requestButtonTap, .activeRequestButtonTap:
                return true
            default:
                return false
            }
        }
    }
    
    // MARK: - Components
    
    private let checkValidationStack: UIStackView = {
        let stack = UIStackView()
        stack.isHidden = true
        stack.axis = .vertical
        return stack
    }()
    
    let checkValidationButton: UIButton = {
        let button = UIButton()
        button.setTitle("중복체크", for: .normal)
        button.titleLabel?.font = .KorFont(style: .regular, size: 13)
        button.setTitleColor(.g1000, for: .normal)
        return button
    }()
    
    private let checkValidationLine: UIView = {
        let line = UIView()
        line.layer.borderColor = UIColor.g300.cgColor
        line.layer.borderWidth = 1
        return line
    }()
    
    // MARK: - Properties
    
    /// 상태 값의 변화를 감지하는 옵저버
    /// bind()에서 텍스트필드의 입력 값에 따라 변경된 값을 적용하는 것을 돕습니다
    let stateObserver:PublishSubject<ValidationState> = .init()
    private var isActive: Bool = false
    private let type: ValidationType
    var myNickName: String? = "$${myNickName}$$"
    // MARK: - Initializer
    
    init(placeHolder: String?, type: ValidationType = .nickName, limitTextCount: Int) {
        self.type = type
        super.init(placeHolder: placeHolder, description: "", limitTextCount: limitTextCount)
        setUpDuplicatecheck()
        bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ValidationTextFieldCPNT {
    
    // MARK: - Methods
    
    func setUpDuplicatecheck() {
        checkValidationStack.addArrangedSubview(checkValidationButton)
        checkValidationStack.addArrangedSubview(checkValidationLine)
        checkValidationLine.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        textFieldStackView.addArrangedSubview(checkValidationStack)
    }
    
    func bind() {
        
        textField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe { (owner, text) in
                let state = owner.fetchValidationState(text: text)
                owner.stateObserver.onNext(state)
            }
            .disposed(by: disposeBag)
        
        // 텍스트 필드가 입력되는 시점을 확인합니다
        textField.rx.controlEvent([.editingDidBegin])
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.isActive = true
                guard let text = owner.textField.text else { return }
                let state = owner.fetchValidationState(text: text)
                owner.stateObserver.onNext(state)
            }
            .disposed(by: disposeBag)
        
        // 텍스트 필드가 입력이 끝날 때를 확인합니다
        textField.rx.controlEvent(.editingDidEnd)
            .withUnretained(self)
            .subscribe {(owner, _) in
                owner.isActive = false
                guard let text = owner.textField.text else { return }
                let state = owner.fetchValidationState(text: text)
                owner.stateObserver.onNext(state)
            }
            .disposed(by: disposeBag)
        
        stateObserver
            .withUnretained(self)
            .subscribe { (owner, state) in
                let output = ValidationOutPut(type: owner.type, state: state)
                owner.setUpViewFrom(output: output)
            }
            .disposed(by: disposeBag)
        
        clearButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, value) in
                owner.textField.text = ""
                owner.setTextLimit(text: "")
                owner.stateObserver.onNext(.none)
            }
            .disposed(by: disposeBag)
    }
    
    /// 텍스트필드 입력 값에 반응하는 메서드
    /// - Parameter text: 텍스트 필드에 입력된 String 타입을 받습니다
    /// - Returns: ValidationState로 상태 값을 반환합니다
    func fetchValidationState(text: String) -> ValidationState {
        return isActive ? fetchWhenActive(text: text) : fetchWhenInactive(text: text)
    }
    
    /// 텍스트필드가 활성화되어 있는 시점의 상태를 반환합니다
    func fetchWhenActive(text: String) -> ValidationState {
        if text == myNickName {
            return .myNickNameActive
        }
        if text.isEmpty {
            return .activeNone
        } else if text.count < 2 {
            return .activeShortText
        } else if text.count > limitTextCount {
            return .activeOverText(limitTextCount)
        } else if !checkIfValid(text: text) {
            return .requestKorOrEn
        } else {
            return .activeRequestButtonTap
        }
    }
    
    /// 텍스트필드가 비활성화되어 있는 시점의 상태를 반환합니다
    func fetchWhenInactive(text: String) -> ValidationState {
        if text == myNickName {
            return .myNickName
        }
        
        if text.isEmpty {
            return .none
        } else if text.count < 2 {
            return .shortText
        } else if text.count > limitTextCount {
            return .overText(limitTextCount)
        } else if !checkIfValid(text: text) {
            return .requestKorOrEn
        } else {
            return .requestButtonTap(text)
        }
    }
    
    /// 텍스트 필드 값이 유효한 문자인지 확인합니다.
    /// *영문, 한글인지 확인합니다
    func checkIfValid(text: String) -> Bool {
        let regex = "^[가-힣A-Za-z0-9\\s]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: text)
    }
    
    /// ValidationOutput 상태 값에 반응하는 메서드
    /// 상태에 맞는 컬러 값을 바꾸고 특정 버튼 등을 숨김 처리합니다.
    /// - Parameter output: 상태 값 타입인 ValidationOutPut을 받습니다
    func setUpViewFrom(output: ValidationOutPut) {
        self.descriptionLabel.text = output.description
        self.descriptionLabel.textColor = output.descriptionColor
        
        self.checkValidationStack.isHidden = output.isDuplicateCheckButtonHidden
        self.checkValidationButton.setTitleColor(output.buttonColor, for: .normal)
        self.checkValidationLine.backgroundColor = output.buttonColor
        self.checkValidationButton.isEnabled = output.isButtonEnabled
        
        self.textFieldBackGroundView.layer.borderColor = output.borderColor.cgColor
        self.textCountLabel.textColor = output.countLabelColor
        self.clearButton.isHidden = output.isClearButtonHidden
    }
}
