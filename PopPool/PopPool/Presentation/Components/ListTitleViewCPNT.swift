//
//  ListTitleViewCPNT.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/15/24.
//

import UIKit
import SnapKit

final class ListTitleViewCPNT: UIStackView {
    enum Size {
        case large(subtitle: String, image: UIImage?)
        case medium
        
        var titleFont: UIFont? {
            switch self {
            case .large:
                return .KorFont(style: .bold, size: 16)
            case .medium:
                return .KorFont(style: .regular, size: 13)
            }
        }
        
        var subTitle: String? {
            switch self {
            case .large(let subtitle, let image):
                return subtitle
            case .medium:
                return nil
            }
        }
        
        var iconImage: UIImage? {
            switch self {
            case .large(let subtitle, let image):
                return image
            case .medium:
                return nil
            }
        }
    }
    
    // MARK: - Components
    let rightButton = TextUnderBarButtonCPNT(size: .small, title: "전체보기")
    let titleLabel: UILabel = UILabel()
    let subTitleLabel: UILabel = UILabel()
    let iconImageView: UIImageView = UIImageView()
    let bottomSpace = UIView()
    let containerView = UIView()
    
    // MARK: - init
    init(title: String?, size: Size) {
        super.init(frame: .zero)
        setUp(title: title, size: size)
        setUpConstraints(size: size)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension ListTitleViewCPNT {
    func setUp(title: String?, size: Size) {
        titleLabel.text = title
        titleLabel.font = size.titleFont
        titleLabel.textColor = .g1000
        subTitleLabel.text = size.subTitle
        subTitleLabel.textColor = .g600
        subTitleLabel.font = .KorFont(style: .regular, size: 13)
        iconImageView.image = size.iconImage
    }
    
    func setUpConstraints(size: Size) {
        switch size {
        case .medium:
            self.addArrangedSubview(titleLabel)
        case .large:
            self.alignment = .center
            containerView.addSubview(titleLabel)
            containerView.addSubview(iconImageView)
            containerView.addSubview(subTitleLabel)
            containerView.addSubview(bottomSpace)
            titleLabel.snp.makeConstraints { make in
                make.top.leading.equalToSuperview()
                make.height.equalTo(22)
            }
            iconImageView.snp.makeConstraints { make in
                make.top.equalTo(titleLabel)
                make.leading.equalTo(titleLabel.snp.trailing).offset(6)
                make.size.equalTo(22)
            }
            subTitleLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(4)
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(20)
            }
            
            bottomSpace.snp.makeConstraints { make in
                make.top.equalTo(subTitleLabel.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(Constants.spaceGuide.small100)
            }

            self.addArrangedSubview(containerView)
        }
        rightButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
        self.addArrangedSubview(rightButton)
    }
}
