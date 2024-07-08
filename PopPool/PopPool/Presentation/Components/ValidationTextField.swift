//
//  ValidationTextField.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ValidationTextField: BaseTextFieldCPNT {
    
    enum ValidationType {
        case nickName
    }
    
    enum ValidationState {
        case none
        case requestKorOrEn
        case requestButtonTap
        case overText
        case shortText
        case buttonTappedOutputError
        case clear
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
                return "2글자까지만 입력할 수 있어요"
            case .buttonTappedOutputError:
                return "이미 사용중인 별명이에요"
            case .clear:
                return "사용 가능한 별명이에요"
            }
        }
    }
    
    let stateObserver:PublishSubject<ValidationState> = .init()
    let type: ValidationType
    init(placeHolder: String?, type: ValidationType = .nickName, limitTextCount: Int) {
        self.type = type
        super.init(placeHolder: placeHolder, description: "", limitTextCount: limitTextCount)
        bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViewFrom(output: ValidationOutPut) {
        self.descriptionLabel.text = output.description
    }
    
    func bind() {
        stateObserver
            .withUnretained(self)
            .subscribe { (owner, state) in
                let output = ValidationOutPut(type: owner.type, state: state)
                owner.setUpViewFrom(output: output)
            }
            .disposed(by: disposeBag)
        
        textField.rx
            .text
            .orEmpty
            .withUnretained(self)
            .subscribe { (owner, text) in
                let state = owner.fetchValidationState(text: text)
                owner.stateObserver.onNext(state)
            }
            .disposed(by: disposeBag)
    }
    
    func fetchValidationState(text: String) -> ValidationState{
        if text.count > 5 {
            return .overText
        }
        return .clear
    }
}
