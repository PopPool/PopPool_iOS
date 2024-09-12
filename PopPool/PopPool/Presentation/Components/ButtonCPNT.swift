//
//  ButtonCPNT.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/20/24.
//

import Foundation
import UIKit
import SnapKit

enum ButtonTYPE {
    case primary
    case secondary
    case kakao
    case apple
    case instagram
    case tertiary
    case dft // Default
}

extension ButtonTYPE {
    
    var backGroundColor: UIColor {
        switch self {
        case .primary:
            return .blu500
        case .secondary:
            return .g50
        case .kakao:
            return .init(hexCode: "F8E049")
        case .apple, .instagram:
            return .g900
        case .tertiary:
            return .clear
        case .dft:
            return .g100
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .primary:
            return .w100
        case .secondary:
            return .blu500
        case .kakao:
            return .black
        case .apple, .instagram:
            return .w100
        case .tertiary:
            return .g300
        case .dft:
            return .g400
        }
    }
    
    var image: UIImage? {
        switch self {
        case .kakao:
            return UIImage(named: "brand=kakao")
        case .apple:
            return UIImage(named: "brand=apple_light")
        case .instagram:
            return UIImage(named: "brand=instagram")
        case .tertiary:
            return UIImage(named: "arrow_down")
        default:
            return nil
        }
    }
    
    var font: UIFont? {
        switch self {
        case .kakao, .apple:
            return .KorFont(style: .medium, size: 15)
        case .instagram:
            return .EngFont(style: .medium, size: 15)
        case .tertiary:
            return .KorFont(style: .regular, size: 13)
        default:
            return .KorFont(style: .medium, size: 16)
        }
    }
}

final class ButtonCPNT: UIButton {
    
    lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    init(type: ButtonTYPE, title: String, disabledTitle: String = "") {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = type.font
        self.setTitle(disabledTitle, for: .disabled)
        self.setTitleColor(.g400, for: .disabled)
        self.setBackgroundColor(.g100, for: .disabled)
        setUpLayer()
        setUpButtonType(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ButtonCPNT {
    
    /// Layer 설정
    func setUpLayer() {
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.configuration?.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
    }
    
    /// 각 타입별 버튼 설정
    /// - Parameter type: TYPEButton
    func setUpButtonType(type: ButtonTYPE) {
        self.backgroundColor = type.backGroundColor
        self.setTitleColor(type.titleColor, for: .normal)
        
        switch type {
        case .apple:
            self.setTitleColor(.w90, for: .highlighted)
            setIconImageView(image: type.image)
        case .kakao:
            setIconImageView(image: type.image)
        case .instagram:
            self.setTitleColor(.w100, for: .highlighted)
            setIconImageView(image: type.image)
        case .tertiary:
            titleLabel?.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(12)
            }
            setEndIconImage(image: type.image)
            self.layer.borderColor = UIColor.g200.cgColor
            self.layer.borderWidth = 1
        default:
            self.setBackgroundColor(.pb7, for: .highlighted)
        }
    }
    
    /// 버튼 배경색 설정
    /// - Parameters:
    ///   - color: 색상
    ///   - state: 상태
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))

        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
    
    /// 아이콘 이미지 뷰 설정
    /// - Parameter image: 이미지
    func setIconImageView(image: UIImage?) {
        self.iconImageView.image = image
        if let image = self.iconImageView.image {
            let aspectRatio = image.size.width / image.size.height
            self.addSubview(iconImageView)
            iconImageView.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(20)
                make.height.equalTo(22)
                make.width.equalTo(iconImageView.snp.height).multipliedBy(aspectRatio)
                make.centerY.equalToSuperview()
            }
        }
    }
    
    func setEndIconImage(image: UIImage?) {
        self.iconImageView.image = image
        if let image = self.iconImageView.image {
            let aspectRatio = image.size.width / image.size.height
            self.addSubview(iconImageView)
            iconImageView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(8)
                make.height.equalTo(16)
                make.width.equalTo(iconImageView.snp.height).multipliedBy(aspectRatio)
                make.centerY.equalToSuperview()
            }
            
        }
    }
}
