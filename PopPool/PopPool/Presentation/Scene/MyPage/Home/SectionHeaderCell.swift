//
//  SectionHeaderCell.swift
//  PopPool
//
//  Created by Porori on 8/18/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

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
    var disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Methods
    
    public func configure(title: String) {
        let style = NSMutableParagraphStyle()
        let text = NSMutableAttributedString(
            string: title,
            attributes: [.paragraphStyle: style])
        style.lineHeightMultiple = 1.4
        titleLabel.attributedText = text
    }
    
    public func configureWhite(title: String) {
        titleLabel.text = title
        titleLabel.textColor = .w100
    }
    
    private func setUp() {
        actionButton.setImage(
            UIImage(named: "line_signUp")?
                .withTintColor(.black, renderingMode: .alwaysOriginal),
            for: .normal)
    }
    
    private func setUpConstraint() {
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        buttonContainer.addSubview(actionButton)
        buttonContainer.setContentHuggingPriority(.required, for: .horizontal)
        actionButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview()
        }
    }
}
