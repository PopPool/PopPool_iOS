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
        case requestKorOrEn
        case requestButtonTap
        case overText
        case shortText
        case buttonTapError
        case valid
    }
    
    struct ValidationOutPut {
        var type: ValidationType
        var state: ValidationState
        
        var description: String? {
            switch state {
            case .none:
                return nil
            case .requestKorOrEn:
                return "한글, 영문으로만 입력해주세요"
            case .requestButtonTap:
                return "중복체크를 진행해주세요"
            case .overText:
                return "10글자까지만 입력할 수 있어요"
            case .shortText:
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
            case .overText, .buttonTapError, .shortText, .requestKorOrEn:
                return UIColor.re500
            case .none:
                return UIColor.g100
            case .valid, .requestButtonTap:
                return UIColor.g1000
            }
        }
        
        /// 텍스트필드 하단의 획의 count 컬러값
        var countLabelColor: UIColor {
            switch state {
            case .overText, .shortText:
                return UIColor.re500
            default:
                return UIColor.g500
            }
        }
        
        /// 텍스트필드 하단의 각 설명의 컬러값
        var descriptionColor: UIColor {
            switch state {
            case .overText, .buttonTapError, .shortText, .requestKorOrEn:
                return UIColor.re500
            case .none, .requestButtonTap:
                return UIColor.g500
            case .valid:
                return UIColor.blu500
            }
        }
        
        /// state별로 x 버튼의 출력 여부
        var isClearButtonHidden: Bool {
            switch state {
            case .shortText, .buttonTapError, .overText, .requestButtonTap:
                return false
            case .none, .requestKorOrEn, .valid:
                return true
            }
        }
        
        /// state별로 '중복체크' 버튼의 출력 여부
        var isDuplicateCheckButtonHidden: Bool {
            switch state {
            case .none :
                return false
            default:
                return true
            }
        }
    }
    
    // MARK: - Components
    
    private let checkValidationStack: UIStackView = {
        let stack = UIStackView()
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
    let nameObserver: PublishSubject<String?> = .init()
    private let type: ValidationType
    
    // MARK: - Initializer
    
    init(placeHolder: String?, type: ValidationType = .nickName, limitTextCount: Int) {
        self.type = type
        super.init(placeHolder: placeHolder, description: "", limitTextCount: limitTextCount)
        setUpDuplicatecheck()
        bind()
    }
    
    // MARK: - Methods
    
    private func setUpDuplicatecheck() {
        checkValidationStack.addArrangedSubview(checkValidationButton)
        checkValidationStack.addArrangedSubview(checkValidationLine)
        checkValidationLine.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        textFieldStackView.addArrangedSubview(checkValidationStack)
    }
    
    private func bind() {
        
        textField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe { (owner, text) in
                let state = owner.fetchValidationState(text: text)
                owner.stateObserver.onNext(state)
            }
            .disposed(by: disposeBag)
        
        // 텍스트 입력 이후 '중복체크' 버튼이 보이기 위한 controlEvent binding
        textField.rx.controlEvent([.editingDidEnd])
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.checkValidationStack.isHidden = false
            }
            .disposed(by: disposeBag)
        
        stateObserver
            .withUnretained(self)
            .subscribe { (owner, state) in
                let output = ValidationOutPut(type: owner.type, state: state)
                owner.setUpViewFrom(output: output)
                
                if state == .valid {
                    guard let nickName = owner.textField.text else { return }
                    self.nameObserver.onNext(nickName)
                } else {
                    self.nameObserver.onNext(nil)
                }
            }
            .disposed(by: disposeBag)
        
        clearButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, value) in
                owner.textField.text = ""
                owner.stateObserver.onNext(.none)
            }
            .disposed(by: disposeBag)
        
        checkValidationButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                // 중복체크 버튼 탭 이후 처리
                print("중복 체크 버튼이 눌렸습니다.")
            }
            .disposed(by: disposeBag)
    }
    
    /// 텍스트필드 입력 값에 반응하는 메서드
    /// - Parameter text: 텍스트 필드에 입력된 String 타입을 받습니다
    /// - Returns: ValidationState로 상태 값을 반환합니다
    private func fetchValidationState(text: String) -> ValidationState {
        if text.count == 0 {
            return .none
        } else if text.count < 2 {
            return .shortText
        } else if text.count > 10 {
            return .overText
        }
        
        // 국문, 영문을 확인하는 Regex 코드
        let regex = "^[가-힣A-Za-z0-9\\s]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if !predicate.evaluate(with: text) {
            return .requestKorOrEn
        }
        return .requestButtonTap
    }
    
    /// ValidationOutput 상태 값에 반응하는 메서드
    /// 상태에 맞는 컬러 값을 바꾸고 특정 버튼 등을 숨김 처리합니다.
    /// - Parameter output: 상태 값 타입인 ValidationOutPut을 받습니다
    private func setUpViewFrom(output: ValidationOutPut) {
        
        self.descriptionLabel.text = output.description
        self.descriptionLabel.textColor = output.descriptionColor
        self.textFieldBackGroundView.layer.borderColor = output.borderColor.cgColor
        self.textCountLabel.textColor = output.countLabelColor
        
        self.clearButton.isHidden = output.isClearButtonHidden
        self.checkValidationStack.isHidden = output.isDuplicateCheckButtonHidden
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
