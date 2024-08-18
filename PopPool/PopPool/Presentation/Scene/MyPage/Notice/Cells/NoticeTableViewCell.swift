//
//  NoticeTableViewCell.swift
//  PopPool
//
//  Created by Porori on 7/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NoticeTableViewCell: UITableViewCell {

    static let reuseIdentifier = "NoticeTableViewCell"
    
    // MARK: - Components
    
    private let topSpace = UIView()
    private let bottomSpace = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .bold, size: 14)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 12)
        label.textColor = .g400
        return label
    }()
    
    private lazy var titleLabelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subTitleLabel)
        return stack
    }()
    
    private lazy var titleAndButtonStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(titleLabelStack)
        stack.addArrangedSubview(actionButton)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 16)
        stack.alignment = .center
        return stack
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(topSpace)
        stack.addArrangedSubview(titleAndButtonStack)
        stack.addArrangedSubview(bottomSpace)
        return stack
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "line_signUp"), for: .normal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    /// 셀의 제목과 부제목/날짜를 호출하기 위한 메서드입니다.
    /// - Parameters:
    ///   - title: String 타입을 받습니다.
    ///   - subTitle: String 타입을 받습니다.
    public func updateView(title: String, subTitle: String?) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
    
    private func setUpConstraint() {
        contentView.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topSpace.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small200)
        }
        
        bottomSpace.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small200)
        }
        
        actionButton.snp.makeConstraints { make in
            make.size.equalTo(22)
        }
    }
}
