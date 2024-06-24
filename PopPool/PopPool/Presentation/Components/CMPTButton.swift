//
//  CMPTButton.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/20/24.
//

import Foundation
import UIKit
import SnapKit

enum TYPEButton {
    case primary
    case secondary
    case disabled
    case kakao
    case apple
    case dft // Default
}

extension TYPEButton {
    
    var backGroundColor: UIColor {
        switch self {
        case .primary:
            return .blu500
        case .secondary:
            return .g50
        case .disabled:
            return .g100
        case .kakao:
            return .init(hexCode: "F8E049")
        case .apple:
            return .g900
        case .dft:
            return .g100
        }
    }
    
    var contentsColor: UIColor {
        switch self {
        case .primary:
            return .w100
        case .secondary:
            return .blu500
        case .disabled:
            return .g400
        case .kakao:
            return .black
        case .apple:
            return .w100
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
        default:
            return nil
        }
    }
    
    var font: UIFont? {
        switch self {
        case .kakao, .apple:
            return .KorFont(style: .medium, size: 15)
        default:
            return .KorFont(style: .medium, size: 16)
        }
    }
}

/// 추후 on Tap 등 수정 사항 반영 필요
final class CMPTButton: UIButton {
    
    lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    init(type: TYPEButton, contents: String) {
        super.init(frame: .zero)
        self.setTitle(contents, for: .normal)
        self.titleLabel?.font = type.font
        setUpLayer()
        setUpButtonType(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CMPTButton {
    
    /// Layer 설정
    func setUpLayer() {
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.configuration?.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
    }
    
    /// 각 타입별 버튼 설정
    /// - Parameter type: TYPEButton
    func setUpButtonType(type: TYPEButton) {
        self.backgroundColor = type.backGroundColor
        self.setTitleColor(type.contentsColor, for: .normal)
        
        switch type {
        case .apple:
            self.setTitleColor(.w90, for: .highlighted)
            setIconImageView(image: type.image)
        case .kakao:
            setIconImageView(image: type.image)
        case .disabled:
            self.setTitleColor(.blu500, for: .highlighted)
            self.setBackgroundColor(.g50, for: .normal)
        default:
            self.setBackgroundColor(.pb7, for: .highlighted)
        }
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))

        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
    
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
}
