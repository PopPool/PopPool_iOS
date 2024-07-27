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

class BlockedUserCell: UITableViewCell {
    
    enum ButtonStyle {
        case button(String)
        case icon
        case toggle
    }
    
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
                return .g200
            }
        }
    }

    static let reuseIdentifier = "BlockedUserCell"
        
    // MARK: - Component
    
    private let topSpaceView = UIView()
    private let bottomSpaceView = UIView()
    
    private lazy var containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(topSpaceView)
        stack.addArrangedSubview(profileStack)
        stack.addArrangedSubview(bottomSpaceView)
        return stack
    }()
    
    private let profileImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "person.fill")
        imgView.backgroundColor = .black
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .bold, size: 14)
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 12)
        return label
    }()
    
    lazy var titleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subLabel)
        return stack
    }()
    
    lazy var profileStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(profileImageView)
        stack.addArrangedSubview(titleStack)
        stack.spacing = 12
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    let removeButton: UIButton = {
        let button = UIButton()
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        button.titleLabel?.font = .EngFont(style: .regular, size: 13)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()
    
    let cellStateObserver: BehaviorRelay<UserState> = .init(value: .blocked)
    var disposeBag = DisposeBag()
    
    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        sendSubviewToBack(contentView)
    }
    
    override func layoutSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        bind()
    }
    
    // MARK: - Methods
    
    func bind() {
        // cell의 상태를 확인
        cellStateObserver
            .withUnretained(self)
            .subscribe { (owner, state) in
                self.updateCell(from: state)
            }
            .disposed(by: disposeBag)
        
        removeButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                let newState: UserState = self.cellStateObserver.value == .blocked ? .unblocked : .blocked
                self.cellStateObserver.accept(newState)
            }
            .disposed(by: disposeBag)
    }
    
    // 상태에 따라 셀의 모습을 업데이트
    private func updateCell(from state: UserState) {
        removeButton.setTitle(state.stateDescription, for: .normal)
        removeButton.backgroundColor = state.stateColor
    }
    
    public func configure(title: String, subTitle: String, buttonType: ButtonStyle) {
        let isDate = checkIfDate(input: subTitle)
        titleLabel.text = title
        subLabel.text = isDate
        subLabel.textColor = .g400
        
        switch buttonType {
        case .button(let buttonName):
            removeButton.setTitle(buttonName, for: .normal)
            profileStack.setCustomSpacing(42, after: titleStack)
            profileStack.addArrangedSubview(removeButton)
            
        case .icon:
            removeButton.setImage(UIImage(named: "line_signUp"), for: .normal)
            removeButton.contentMode = .scaleAspectFit
            removeButton.contentEdgeInsets = UIEdgeInsets(top: 9.5, left: 0, bottom: 9.5, right: 0)
            
            removeButton.snp.makeConstraints { make in
                make.width.equalTo(22)
            }
            
            profileStack.setCustomSpacing(42, after: titleStack)
            profileStack.addArrangedSubview(removeButton)
            
        case .toggle:
            let toggle = UISwitch()
            toggle.onTintColor = .blu400
            toggle.bringSubviewToFront(self)
            profileStack.addArrangedSubview(toggle)
        }
        
        bind()
    }
    
    private func setUpConstraints() {
        addSubview(containerStack)

        containerStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constants.spaceGuide.small100)
            make.leading.trailing.equalToSuperview()
        }
                
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(Constants.spaceGuide.medium200)
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
