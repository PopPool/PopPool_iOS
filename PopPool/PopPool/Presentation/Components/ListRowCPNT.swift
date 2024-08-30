//
//  ListRowCPNT.swift
//  PopPool
//
//  Created by Porori on 8/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ListRowCPNT: UIStackView {
    
    enum State {
        case isTapped
        case notTapped
    }
    
    //MARK: - Component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트"
        label.font = .KorFont(style: .bold, size: 18)
        return label
    }()
    
    let iconView: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "check_signUp")
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.setCustomSpacing(42, after: self.titleLabel)
        return stack
    }()
    
    let lineView = UIView()
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let tapGesture = UITapGestureRecognizer()
    var isTapped: State = .notTapped
    let tappedObserver: PublishSubject<State> = .init()
    
    //MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraint()
        bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
        tapGesture.rx.event
            .withUnretained(self)
            .subscribe(onNext: { (owner, event) in
                print("스택이 탭 되었습니다.")
                owner.isTapped = owner.isTapped == .notTapped ? .isTapped : .notTapped
                owner.tappedObserver.onNext(owner.isTapped)
            })
        .disposed(by: disposeBag)
    }
    
    private func setUp() {
        self.axis = .vertical
        self.spacing = CGFloat(Constants.spaceGuide.small100)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(iconView)
        stackView.addGestureRecognizer(tapGesture)
        
        lineView.backgroundColor = .g50
        stackView.isUserInteractionEnabled = true
    }
    
    private func setUpConstraint() {
        self.addArrangedSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(22)
        }
        
        self.addArrangedSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
}
