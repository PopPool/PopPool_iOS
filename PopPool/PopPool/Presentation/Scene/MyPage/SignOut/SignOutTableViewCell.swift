//
//  SignOutTableViewCell.swift
//  PopPool
//
//  Created by Porori on 9/4/24.
//

import UIKit
import SnapKit
import RxRelay
import RxSwift
import RxCocoa

final class SignOutTableViewCell: UITableViewCell {
    
    enum SignOutState {
        case tapped
        case normal
        
        var checkImage: UIImage? {
            switch self {
            case .normal: return UIImage(named: "check_signUp")
            case .tapped: return UIImage(named: "check_fill_signUp")
            }
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.addArrangedSubview(checkButton)
        stack.addArrangedSubview(titleLabel)
        stack.layoutMargins = UIEdgeInsets(top: 13, left: 20, bottom: 12, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.alignment = .center
        return stack
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var currentState: SignOutState = .normal
    let tapStateSubject: BehaviorRelay<SignOutState> = .init(value: .normal)
    var disposeBag = DisposeBag()
    let tapSubject = PublishSubject<(Survey, SignOutState)>()
    private var surveyList: [Survey] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraint()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        sendSubviewToBack(contentView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bind()
        disposeBag = DisposeBag()
    }
    
    private func bind() {
        tapStateSubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, state) in
                owner.currentState = state
                owner.configure(state: state)
            })
            .disposed(by: disposeBag)
        
        checkButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                guard let survey = owner.surveyList.first else { return }
                let newState = owner.currentState == SignOutState.normal ? SignOutState.tapped : SignOutState.normal
                owner.tapStateSubject.accept(newState)
                owner.tapSubject.onNext((survey, newState))
            })
            .disposed(by: disposeBag)
    }
    
    public func configure(data: Survey) {
        titleLabel.text = data.survey
        surveyList = [data]
    }
    
    private func configure(state: SignOutState) {
        checkButton.setImage(state.checkImage, for: .normal)
    }
    
    private func setUpConstraint() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        checkButton.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
    }
}
