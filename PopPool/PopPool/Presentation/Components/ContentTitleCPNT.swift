//
//  ContentTitleCPNT.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/25/24.
//

import Foundation
import UIKit
import SnapKit

// 제목 타입 열거형 정의
enum ContentTitleTYPE {
    case title_sub_fp(subTitle: String)
    case title_fp
    case title_icon_fp(icon: UIImage?)
    case title_sub_bs(subTitle: String, buttonImage: UIImage?)
    case title_bs(buttonImage: UIImage?)
}

// 제목 타입 확장
extension ContentTitleTYPE {
    // 제목 폰트 설정
    var titleFont: UIFont? {
        switch self {
        case .title_sub_fp:
            return .KorFont(style: .bold, size: 20)
        case .title_fp:
            return .KorFont(style: .bold, size: 20)
        case .title_icon_fp:
            return .KorFont(style: .bold, size: 20)
        case .title_sub_bs:
            return .KorFont(style: .bold, size: 18)
        case .title_bs:
            return .KorFont(style: .bold, size: 18)
        }
    }
    
    // 부제 폰트 설정
    var subFont: UIFont? {
        switch self {
        case .title_sub_fp(_):
            return .KorFont(style: .regular, size: 15)
        case .title_sub_bs(_, _):
            return .KorFont(style: .regular, size: 15)
        default:
            return nil
        }
    }
    
    // 제목 색상 설정
    var titleColor: UIColor? {
        switch self {
        default:
            return .g1000
        }
    }
    
    // 부제 색상 설정
    var subTitleColor: UIColor? {
        switch self {
        default:
            return .g600
        }
    }
}

final class ContentTitleCPNT: UIStackView {
    
    // MARK: - Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = . byWordWrapping
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    let button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let subStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        return view
    }()
    
    init(title: String, type: ContentTitleTYPE) {
        super.init(frame: .zero)
        setUp(title: title, type: type)
        setUpViewType(type: type)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ContentTitleCPNT {
    
    /// 기본 설정 메소드
    /// - Parameters:
    ///   - title: 제목
    ///   - type: TYPEContentTitle
    func setUp(title: String, type: ContentTitleTYPE) {
        self.axis = .vertical
        self.spacing = 0
        self.alignment = .fill
        self.distribution = .fill
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        titleLabel.font = type.titleFont
        titleLabel.attributedText = NSMutableAttributedString(
            string: title,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        
        titleLabel.textColor = type.titleColor
        subTitleLabel.font = type.subFont
        subTitleLabel.textColor = type.subTitleColor
    }
    
    /// 뷰 타입별 설정 메소드
    /// - Parameter type: TYPEContentTitle
    func setUpViewType(type: ContentTitleTYPE) {
        let topSpacingView = UIView()
        let middleSpacingView = UIView()
        
        switch type {
        case .title_sub_fp(let subTitle):
            subTitleLabel.text = subTitle
            
            topSpacingView.snp.makeConstraints { make in
                make.height.equalTo(Constants.spaceGuide._64px)
            }
            middleSpacingView.snp.makeConstraints { make in
                make.height.equalTo(Constants.spaceGuide._16px)
            }
            
            self.addArrangedSubview(topSpacingView)
            self.addArrangedSubview(titleLabel)
            self.addArrangedSubview(middleSpacingView)
            self.addArrangedSubview(subTitleLabel)
        case .title_fp:
            topSpacingView.snp.makeConstraints { make in
                make.height.equalTo(Constants.spaceGuide._64px)
            }
            
            self.addArrangedSubview(topSpacingView)
            self.addArrangedSubview(titleLabel)
        case .title_icon_fp(let icon):
            iconImageView.image = icon
            self.alignment = .leading
            subStackView.spacing = 10
            
            topSpacingView.snp.makeConstraints { make in
                make.height.equalTo(Constants.spaceGuide._64px)
            }

            iconImageView.snp.makeConstraints { make in
                make.size.equalTo(Constants.spaceGuide._24px)
            }
            
            subStackView.addArrangedSubview(titleLabel)
            subStackView.addArrangedSubview(iconImageView)
            self.addArrangedSubview(topSpacingView)
            self.addArrangedSubview(subStackView)
        case .title_sub_bs(let subTitle, let buttonImage):
            subTitleLabel.text = subTitle
            button.setImage(buttonImage, for: .normal)
            
            topSpacingView.snp.makeConstraints { make in
                make.height.equalTo(Constants.spaceGuide._32px)
            }
            middleSpacingView.snp.makeConstraints { make in
                make.height.equalTo(Constants.spaceGuide._8px)
            }
            button.snp.makeConstraints { make in
                make.size.equalTo(24)
            }
            
            subStackView.addArrangedSubview(titleLabel)
            subStackView.addArrangedSubview(button)
            self.addArrangedSubview(topSpacingView)
            self.addArrangedSubview(subStackView)
            self.addArrangedSubview(middleSpacingView)
            self.addArrangedSubview(subTitleLabel)
        case .title_bs(let buttonImage):
            button.setImage(buttonImage, for: .normal)
            
            topSpacingView.snp.makeConstraints { make in
                make.height.equalTo(Constants.spaceGuide._32px)
            }
            button.snp.makeConstraints { make in
                make.size.equalTo(24)
            }
            
            subStackView.addArrangedSubview(titleLabel)
            subStackView.addArrangedSubview(button)
            self.addArrangedSubview(topSpacingView)
            self.addArrangedSubview(subStackView)
        }
    }
}

extension ContentTitleCPNT {
    /// 제목 attributedText설정
    /// - Parameter attributedText: NSAttributedString 값
    func setTitleLabel(attributedText: NSAttributedString) {
        titleLabel.attributedText = attributedText
    }
}
