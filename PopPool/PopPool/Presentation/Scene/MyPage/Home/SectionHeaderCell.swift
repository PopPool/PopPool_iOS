//
//  SectionHeaderCell.swift
//  PopPool
//
//  Created by Porori on 8/18/24.
//

import UIKit
import SnapKit
import RxSwift

final class SectionHeaderCell: UICollectionViewCell {
    
    enum CaseState {
        case isLayoutDark
        case isLayoutLight
        
        var textColor: UIColor? {
            switch self {
            case .isLayoutDark: return .w100
            case .isLayoutLight: return .g1000
            }
        }
    }
    
    // MARK: - Component
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(buttonContainer)
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .bold, size: 16)
        label.numberOfLines = 2
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let buttonContainer = UIView()
    private let spaceView = UIView()
    
    // MARK: - Properties
    
    var actionTapped: Observable<Void> {
        return actionButton.rx.tap.asObservable()
    }
    
    let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func configure(title: String) {
        titleLabel.text = title
    }
    
    public func configureWhite(title: String) {
        titleLabel.text = title
        titleLabel.textColor = .w100
        setButtonLayout(title: "전체보기", color: .white)
    }
    
    private func setUp() {
        setButtonLayout(title: "전체보기", color: .black)
    }
    
    private func setButtonLayout(title: String, color: UIColor) {
        let attributes: [NSMutableAttributedString.Key: Any] = [
            .font: UIFont.KorFont(style: .regular, size: 13),
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: color
        ]
        let attributedString = NSMutableAttributedString(string: title,
                                                         attributes: attributes)
        actionButton.setAttributedTitle(attributedString, for: .normal)
        actionButton.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private func setUpConstraint() {
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        buttonContainer.addSubview(actionButton)
        buttonContainer.setContentHuggingPriority(.required, for: .horizontal)
        actionButton.snp.makeConstraints { make in
            
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview()
        }
    }
}
