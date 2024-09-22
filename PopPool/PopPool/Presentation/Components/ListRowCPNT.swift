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
        
        var imageColor: UIImage? {
            switch self {
            case .isTapped:
                return UIImage(named: "check_signUp")?.withTintColor(.blue, renderingMode: .alwaysOriginal)
            case .notTapped:
                return UIImage(named: "check_signUp")
            }
        }
    }
    
    //MARK: - Component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트"
        label.font = .KorFont(style: .regular, size: 15)
        return label
    }()
    
    let iconView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "check_signUp")
        view.image = image
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.setCustomSpacing(42, after: self.titleLabel)
        return stack
    }()
    
    let topSpaceView = UIView()
    let bottomSpaceView = UIView()
    let lineView = UIView()
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let tapGesture = UITapGestureRecognizer()
    var isTapped: State = .notTapped
    let tappedObserver: PublishSubject<State> = .init()
    
    //MARK: - Initializer
    
    init(title: String, image: UIImage?) {
        super.init(frame: .zero)
        setUp(title: title, image: image)
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
                owner.isTapped = owner.isTapped == .notTapped ? .isTapped : .notTapped
                owner.tappedObserver.onNext(owner.isTapped)
            })
            .disposed(by: disposeBag)
        
        tappedObserver
            .subscribe(onNext: { [weak self] status in
                self?.updateView(state: status)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateView(state: State) {
        iconView.image = state.imageColor
    }
    
    private func setUp(title: String, image: UIImage?) {
        self.axis = .vertical
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(iconView)
        self.addGestureRecognizer(tapGesture)
        
        lineView.backgroundColor = .g50
        stackView.isUserInteractionEnabled = true
        
        // 셋업
        titleLabel.text = title
    }
    
    private func setUpConstraint() {
        self.addArrangedSubview(topSpaceView)
        self.addArrangedSubview(stackView)
        self.addArrangedSubview(bottomSpaceView)
        self.addArrangedSubview(lineView)
        
        topSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small100)
        }
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(22)
        }
        
        bottomSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small100)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
}
