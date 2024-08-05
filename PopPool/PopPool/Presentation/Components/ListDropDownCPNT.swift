//
//  ListDropDownCPNT.swift
//  PopPool
//
//  Created by Porori on 8/5/24.
//

import UIKit
import RxSwift
import SnapKit

final class ListDropDownCPNT: UIStackView {
    
    enum DropDownState {
        case active
        case inactive
    }
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.addArrangedSubview(dropDownNoticeStack)
        stack.addArrangedSubview(actionButton)
        return stack
    }()
    
    private lazy var dropDownNoticeStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.addArrangedSubview(questionLabel)
        stack.addArrangedSubview(titleLabel)
        return stack
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .EngFont(style: .bold, size: 16)
        label.textColor = .blu500
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 14)
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow_up"), for: .normal)
        return button
    }()
    
    private let lineContainerView: UIView = {
        let container = UIView()
        return container
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .g50
        return view
    }()
    
    private let dropDownText: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 14)
        label.textColor = .g600
        return label
    }()
    
    private let dropDownContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .pb4
        return view
    }()
    
    private let topSpaceView = UIView()
    private let bottomSpaceView = UIView()
    private let disposeBag = DisposeBag()
    
    var buttonStateObserver: PublishSubject<DropDownState> = .init()
    private var buttonState: DropDownState = .inactive
    
    init() {
        super.init(frame: .zero)
        setUp()
        setUpConstraints()
        bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        actionButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                let currentState: DropDownState = owner.buttonState == .active ? .inactive : .active
                owner.buttonState = currentState
                owner.buttonStateObserver.onNext(currentState)
            }.disposed(by: disposeBag)
        
        buttonStateObserver
            .withUnretained(self)
            .subscribe { (owner, state) in
                print(state)
                owner.updateUI(from: state)
            }.disposed(by: disposeBag)
    }
    
    private func setUp() {
        self.axis = .vertical
        questionLabel.text = "Q"
        titleLabel.text = "제목명"
        dropDownText.text = "내용 텍스트"
    }
    
    private func setUpConstraints() {
        dropDownNoticeStack.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        
        contentStack.setCustomSpacing(42, after: dropDownNoticeStack)
        
        lineContainerView.addSubview(lineView)
        addArrangedSubview(topSpaceView)
        addArrangedSubview(contentStack)
        addArrangedSubview(bottomSpaceView)
        addArrangedSubview(lineContainerView)
        
        topSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small100).priority(.high)
        }
        
        bottomSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small100).priority(.high)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.trailing.leading.equalToSuperview().inset(22)
        }
    }
    
    private func updateUI(from state: DropDownState) {
        switch state {
        case .active:
            self.actionButton.setImage(UIImage(named: "arrow_down"), for: .normal)
            self.setUpDropDown()
        case .inactive:
            self.actionButton.setImage(UIImage(named: "arrow_up"), for: .normal)
            self.dropDownContainer.removeFromSuperview()
        }
    }
    
    private func setUpDropDown() {
        addSubview(dropDownContainer)
        dropDownContainer.addSubview(dropDownText)
        
        dropDownContainer.snp.makeConstraints { make in
            make.top.equalTo(lineContainerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(54)
        }

        dropDownText.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(44)
            make.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(16)
        }
        
        layoutIfNeeded()
    }
}
