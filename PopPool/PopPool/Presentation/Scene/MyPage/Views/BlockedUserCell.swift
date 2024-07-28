//
//  BlockedUserCell.swift
//  PopPool
//
//  Created by Porori on 7/24/24.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

final class BlockedUserCell: UITableViewCell {
    
    enum UserState {
        case blocked
        case unblocked
        
        var stateDescription: String? {
            switch self {
            case .blocked:
                return "차단 완료"
            case .unblocked:
                return "차단 해제"
            }
        }
        
        var stateColor: UIColor {
            switch self {
            case .blocked:
                return .re600
            case .unblocked:
                return .w30
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .blocked:
                return .w100
            case .unblocked:
                return .g400
            }
        }
        
        var borderColor: UIColor? {
            switch self {
            case .blocked:
                return nil
            case .unblocked:
                return .g200
            }
        }
        
        var borderWidth: CGFloat {
            switch self {
            case .blocked:
                return 0
            case .unblocked:
                return 1
            }
        }
    }
    
    // MARK: - Component
    private lazy var containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(topSpaceView)
        stack.addArrangedSubview(component)
        stack.addArrangedSubview(bottomSpaceView)
        return stack
    }()
    
    private let topSpaceView = UIView()
    private let bottomSpaceView = UIView()
    private let component: ListInfoButtonCPNT = ListInfoButtonCPNT(infoTitle: "메인 텍스트",
                                                                   subTitle: "서브 텍스트",
                                                                   style: .button("버튼 텍스트"))
    
    static let reuseIdentifier = "BlockedUserCell"
    private let cellStateRelay: BehaviorRelay<UserState> = .init(value: .blocked)
    let stateChangeSubject = PublishSubject<UserState>()
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraints()
        bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        sendSubviewToBack(contentView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        bind()
    }
    
    // MARK: - Methods
    
    private func bind() {
        cellStateRelay
            .withUnretained(self)
            .subscribe { (owner, state) in
                owner.setUpComponent(from: state)
            }
            .disposed(by: disposeBag)
        
        component.actionButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                let newState = owner.fetchState()
                owner.stateChangeSubject.onNext(newState)
                owner.cellStateRelay.accept(newState)
            }
            .disposed(by: disposeBag)
    }
    
    public func configure(title: String, subTitle: String, initialState: UserState) {
        component.update(title: title, subTitle: subTitle)
        cellStateRelay.accept(initialState)
    }
    
    private func fetchState() -> UserState {
        self.cellStateRelay.value == .blocked ? .unblocked : .blocked
    }
        
    private func setUpComponent(from state: UserState) {
        component.actionButton.setTitle(state.stateDescription, for: .normal)
        component.actionButton.setTitleColor(state.textColor, for: .normal)
        component.actionButton.backgroundColor = state.stateColor
        component.actionButton.layer.borderColor = state.borderColor?.cgColor
        component.actionButton.layer.borderWidth = state.borderWidth
    }
    
    private func setUpConstraints() {
        addSubview(containerStack)

        containerStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    /// Date 타입으로 변환 가능 여부를 파악하여 날짜 혹은 String을 반환합니다
    /// - Parameter input: userId 혹은 날짜를 받습니다
    /// - Returns: String 타입을 반환합니다
    private func checkIfDate(input: String) -> String {
        
        // 서버에서 받는 Date 형식에 따라 ISODateFormatter 활용 여부 변경 예정
        let isoDateFomatter = ISO8601DateFormatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        if let date = isoDateFomatter.date(from: input) {
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        } else {
            return input
        }
    }
}
