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
}

extension TYPEButton {
    
    /// 추후 수정 필요
    var backGroundColor: UIColor {
        switch self {
        case .primary:
            return .systemBlue
        case .secondary:
//            return .g50
            return .g100
        case .disabled:
            return .g100
        }
    }
    
    /// 추후 수정 필요
    var contentsColor: UIColor {
        switch self {
        case .primary:
            return .w100
        case .secondary:
            return .blu500
        case .disabled:
            return .g400
        }
    }
}

/// 추후 on Tap 등 수정 사항 반영 필요
final class CMPTButton: UIButton {

    // MARK: - Components
    private let contentsLabel: UILabel = {
        let label = UILabel()
//        label.font = .customFonts(language: .ko, type: .medium, size: 16)
        label.textAlignment = .center
        return label
    }()
    
    init(type: TYPEButton, contents: String) {
        super.init(frame: .zero)
        contentsLabel.text = contents
        setUpLayer()
        setUpConstraints()
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
    }
    
    /// Constraints 설정
    func setUpConstraints() {
        self.addSubview(contentsLabel)
        contentsLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    /// 각 타입별 버튼 설정
    /// - Parameter type: TYPEButton
    func setUpButtonType(type: TYPEButton) {
        self.backgroundColor = type.backGroundColor
        self.contentsLabel.textColor = type.contentsColor
        self.setBackgroundColor(.pb7, for: .highlighted)
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
}
