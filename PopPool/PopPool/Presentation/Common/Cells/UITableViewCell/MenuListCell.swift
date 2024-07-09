//
//  MenuListCell.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/10/24.
//

import UIKit
import SnapKit

final class MenuListCell: UITableViewCell {
    
    // MARK: - Components
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 15)
        return label
    }()
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 13)
        return label
    }()
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "line_signUp")
        return view
    }()

    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension MenuListCell {
    func setUp() {
        
    }
    
    func setUpConstraints() {
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constants.spaceGuide.small100)
            make.leading.equalToSuperview().inset(22)
            make.trailing.equalToSuperview().inset(18)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(23)
        }
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(23)
        }
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(subTitleLabel)
        contentStackView.addArrangedSubview(iconImageView)
    }
}

// MARK: - Methods
extension MenuListCell {
    
    /// 셀을 구성하는 메서드
    /// - Parameter title: 라벨에 표시할 문자열
    func configure(title: String?, subTitle: String? = nil, subTitleColor: UIColor? = nil) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        subTitleLabel.textColor = subTitleColor
    }
}
