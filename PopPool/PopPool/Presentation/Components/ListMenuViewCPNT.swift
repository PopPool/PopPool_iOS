//
//  ListMenuViewCPNT.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/26/24.
//

import UIKit
import SnapKit

final class ListMenuViewCPNT: UIView {
    
    // MARK: - Style
    enum ListMenuViewStyle {
        case normal
        case info(String?)
        case filter(String?)
        
        var titleFont: UIFont? {
            switch self {
            case .normal, .info:
                return .KorFont(style: .regular, size: 15)
            case .filter:
                return .KorFont(style: .regular, size: 13)
            }
        }
        
        var iconImage: UIImage? {
            switch self {
            case .normal, .info:
                return UIImage(named: "line_signUp")
            case .filter:
                return UIImage(named: "bottomArrow_signUp")
            }
        }
        
        var rightTitle: String? {
            switch self {
            case .normal:
                return nil
            case .info(let string):
                return string
            case .filter(let string):
                return string
            }
        }
        
        var titleTextColor: UIColor {
            switch self {
            case .normal, .info:
                return .g1000
            case .filter:
                return .g400
            }
        }
        
        var rightTextColor: UIColor? {
            switch self {
            case .normal:
                return nil
            case .info:
                return .blu500
            case .filter:
                return .g1000
            }
        }
    }
    
    // MARK: - Components
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let rightStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 6
        return view
    }()
    let rightLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 13)
        label.textColor = .g1000
        return label
    }()
    let iconImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    let filterButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    // MARK: - init
    init(title: String, style: ListMenuViewStyle) {
        super.init(frame: .zero)
        setUp(style: style)
        setUpConstraints()
        injectionWith(input: .init(title: title, rightTitle: style.rightTitle))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension ListMenuViewCPNT {
    
    func setUp(style: ListMenuViewStyle) {
        titleLabel.font = style.titleFont
        iconImageView.image = style.iconImage
        titleLabel.textColor = style.titleTextColor
        rightLabel.textColor = style.rightTextColor
    }
    
    func setUpConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(22)
        }
        rightStackView.addArrangedSubview(rightLabel)
        rightStackView.addArrangedSubview(iconImageView)
        self.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(22)
            make.trailing.equalToSuperview().inset(18)
            make.top.bottom.equalToSuperview().inset(Constants.spaceGuide.small100)
        }
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(rightStackView)
        rightStackView.addSubview(filterButton)
        filterButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - InputableView
extension ListMenuViewCPNT: InputableView {
    
    struct Input {
        var title: String
        var rightTitle: String?
    }
    
    func injectionWith(input: Input) {
        titleLabel.text = input.title
        rightLabel.text = input.rightTitle
    }
}
