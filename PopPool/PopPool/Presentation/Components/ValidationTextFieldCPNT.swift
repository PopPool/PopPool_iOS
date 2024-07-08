//
//  ValidationTextFieldCPNT.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/29/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class ValidationTextFieldCPNT: UIStackView {
    
    enum ContentType {
        case nickname
        case social
        case email(SocialTYPE)

        var placeholder: String {
            switch self {
            case .email:
                return "이메일 주소를 입력해주세요"
            case .nickname:
                return "별명을 입력해주세요"
            case .social:
                return "인스타그램 ID를 입력해주세요"
            }
        }
        
        var description: String {
            switch self {
            case .email(let email):
                if email.rawValue == "apple" {
                    return "애플에 연동된 이메일 주소입니다"
                } else {
                    return "카카오에 연동된 이메일 주소입니다"
                }
            case .nickname:
                return "사용중인 별명이에요"
            case .social:
                return "인스타그램 코멘트와 마이페이지에 ID가 노출됩니다"
            }
        }
    }
    
    enum NickNameValidationState {
        case available
        case none
        case requiredDuplicateCheck
        case requiredKrOrEn
        case shortLength
        case longLength
        case duplicateNickname
        
        var description: String? {
            switch self {
            case .available:
                return "사용 가능한 별명이에요"
            case .none:
                return nil
            case .requiredDuplicateCheck:
                return "중복체크를 진행해주세요"
            case .requiredKrOrEn:
                return "한글, 영문으로만 입력해주세요"
            case .shortLength:
                return "2글자 이상 입력해주세요"
            case .longLength:
                return "10글자까지만 입력할 수 있어요"
            case .duplicateNickname:
                return "이미 사용되고 있는 별명이에요"
            }
        }
        
        var descriptionIsHidden: Bool {
            switch self {
            case .none:
                return true
            default:
                return false
            }
        }
        var borderColor: UIColor {
            switch self {
            case .none:
                return .g200
            case .available, .requiredDuplicateCheck:
                return .g700
            default:
                return .re500
            }
        }
        var cancelButtonIsHidden: Bool {
            switch self {
            case .requiredDuplicateCheck:
                return true
            default:
                return false
            }
        }
        var duplicateCheckButtonIsHidden: Bool {
            switch self {
            case .requiredDuplicateCheck:
                return false
            default:
                return true
            }
        }
        var textColor: UIColor {
            switch self {
            case .available, .requiredDuplicateCheck, .none:
                return .g1000
            default:
                return .re500
            }
        }
        var descriptionColor: UIColor {
            switch self {
            case .available:
                return .blu500
            case .requiredDuplicateCheck:
                return .g500
            default:
                return .re500
            }
            
        }
        var countColor: UIColor {
            switch self {
            case .available, .requiredDuplicateCheck, .none:
                return .g500
            default:
                return .re500
            }
        }
    }
    
    // MARK: - Components
    private let textFieldTrailingView: UIView = {
        let view = UIView()
        return view
    }()
    private let textFieldStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 1
        return view
    }()
    private let textField: UITextField = {
        let textField = UITextField()
        textField.font = .KorFont(style: .medium, size: 14)
        return textField
    }()
    private let cancelButton: UIButton = {
        let button = UIButton()
        let backgroudImage = UIImage(named: "cancel_signUp")
        button.setBackgroundImage(backgroudImage, for: .normal)
        button.setBackgroundImage(backgroudImage, for: .highlighted)
        return button
    }()
    private let duplicationCheckStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.isHidden = true
        return view
    }()
    let duplicationCheckButton: UIButton = {
        let button = UIButton()
        button.setTitle("중복체크", for: .normal)
        button.titleLabel?.font = .KorFont(style: .regular, size: 13)
        button.setTitleColor(.g1000, for: .normal)
        return button
    }()
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .g1000
        return view
    }()
    private let validationStackView: UIStackView = {
        let view = UIStackView()
        view.directionalLayoutMargins = .init(top: 0, leading: 4, bottom: 0, trailing: 4)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    private let validationLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 12)
        label.text = "하이"
        return label
    }()
    private let textCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .KorFont(style: .regular, size: 12)
        label.textColor = .g500
        return label
    }()
    
    let validationState: BehaviorRelay<NickNameValidationState> = .init(value: .none)
    let nickNameObserver: PublishSubject<String?> = .init()
    private let disposeBag = DisposeBag()
    
    init(type: ContentType) {
        super.init(frame: .zero)
        switch type {
        case .nickname:
            setUp(type: type)
            setUpConstraints()
            bind()
            
        case .social:
            setUp(type: type)
            setUpConstraints()
            bind()
            
            
            
        case .email:
            setUp(type: type)
            setUpConstraints()
            bind()
            
            textFieldTrailingView.backgroundColor = UIColor.g200
            textField.isUserInteractionEnabled = false
            cancelButton.isHidden = true
            textCountLabel.isHidden = true
            duplicationCheckStackView.isHidden = true
            
            if let text = textField.text, !text.isEmpty {
                validationLabel.text = type.description
            } else {
                validationLabel.text = type.description
                textField.placeholder = type.placeholder
            }
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - SetUp
private extension ValidationTextFieldCPNT {
    
    /// 초기 설정을 수행하는 메서드
    /// - Parameter placeholder: 텍스트 필드의 플레이스홀더
    func setUp(type: ContentType) {
        self.axis = .vertical
        self.spacing = 6
        textFieldTrailingView.layer.borderWidth = 1.2
        textFieldTrailingView.layer.borderColor = UIColor.g100.cgColor
        textFieldTrailingView.layer.cornerRadius = 4
        
        textField.attributedPlaceholder = NSAttributedString(
            string: type.placeholder,
            attributes: [
                .foregroundColor: UIColor.g200,
                .font: UIFont.KorFont(style: .medium, size: 14)!
            ]
        )
    }
    
    /// 제약 조건을 설정하는 메서드
    func setUpConstraints() {
        textFieldTrailingView.addSubview(textFieldStackView)
        textFieldStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.spaceGuide.small200)
            make.top.equalToSuperview().inset(16)
            make.height.equalTo(21)
            make.bottom.equalToSuperview().inset(15)
        }
        validationStackView.addArrangedSubview(validationLabel)
        validationStackView.addArrangedSubview(textCountLabel)
        validationLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        duplicationCheckStackView.addArrangedSubview(duplicationCheckButton)
        duplicationCheckStackView.addArrangedSubview(lineView)
        duplicationCheckButton.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        textFieldStackView.addArrangedSubview(textField)
        textFieldStackView.addArrangedSubview(cancelButton)
        textFieldStackView.addArrangedSubview(duplicationCheckStackView)
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(21)
        }
        self.addArrangedSubview(textFieldTrailingView)
        self.addArrangedSubview(validationStackView)
    }
    
    /// 바인딩 설정을 수행하는 메서드
    func bind() {
        textField.rx.text.orEmpty
            .withUnretained(self)
            .debounce(.microseconds(300), scheduler: MainScheduler.instance)
            .subscribe { (owner, nickName) in
                owner.changeNickNameCount(nickname: nickName)
                owner.checkValidation(nickName: nickName)
            } onError: { error in
                ToastMSGManager.createToast(message: "TextFieldError")
            }
            .disposed(by: disposeBag)
        validationState
            .withUnretained(self)
            .subscribe { (owner, state) in
                if state == .available {
                    guard let nickName = owner.textField.text else { return }
                    owner.nickNameObserver.onNext(nickName)
                } else {
                    owner.nickNameObserver.onNext(nil)
                }
                owner.changeView(state: state)
            } onError: { error in
                ToastMSGManager.createToast(message: "ValidationStateError")
            }
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.textField.text = ""
                owner.validationState.accept(.none)
                owner.changeNickNameCount(nickname: "")
            }
            .disposed(by: disposeBag)
    }
    
    /// nickName 유효성을 검사하는 메서드
    /// - Parameter nickName: 입력된 별명
    func checkValidation(nickName: String) {
        if nickName.count == 0 {
            validationState.accept(.none)
            return
        }
        if nickName.count < 2 {
            validationState.accept(.shortLength)
            return
        }
        if nickName.count > 10 {
            validationState.accept(.longLength)
            return
        }
        
        // 한글, 영어, 숫자, 공백을 허용하는 정규 표현식
        let regex = "^[가-힣A-Za-z0-9\\s]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if !predicate.evaluate(with: nickName) {
            validationState.accept(.requiredKrOrEn)
            return
        }
        validationState.accept(.requiredDuplicateCheck)
    }
    
    /// 뷰를 변경하는 메서드
    /// - Parameter state: 닉네임 유효성 상태
    func changeView(state: NickNameValidationState) {
            self.validationLabel.isHidden = state.descriptionIsHidden
            self.cancelButton.isHidden = state.cancelButtonIsHidden
            self.validationLabel.text = state.description
            self.textFieldTrailingView.layer.borderColor = state.borderColor.cgColor
            self.duplicationCheckStackView.isHidden = state.duplicateCheckButtonIsHidden
            self.textCountLabel.textColor = state.countColor
            self.validationLabel.textColor = state.descriptionColor
    }
    
    /// 닉네임 글자 수를 변경하는 메서드
    /// - Parameter nickname: 입력된 닉네임
    func changeNickNameCount(nickname: String) {
        let count = nickname.count
            self.textCountLabel.text = "\(count) / 10 자"
    }
}
