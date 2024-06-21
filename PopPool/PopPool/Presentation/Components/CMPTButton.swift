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
    case activated_primary
    case activated_secondary
    case disabled
}

extension TYPEButton {
    
    /// 추후 수정 필요
    var backGroundColor: UIColor {
        switch self {
        case .activated_primary:
            return UIColor.blue
        case .activated_secondary:
            return UIColor.systemBlue
        case .disabled:
            return UIColor.systemGray
        }
    }
    
    /// 추후 수정 필요
    var contentsColor: UIColor {
        switch self {
        case .activated_primary:
            return UIColor.white
        case .activated_secondary:
            return UIColor.white
        case .disabled:
            return UIColor.black
        }
    }
}

/// 추후 on Tap 등 수정 사항 반영 필요
final class CMPTButton: UIButton {

    // MARK: - Components
    private let contentsLabel: UILabel = UILabel()

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
            make.height.equalTo(52)
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    /// 각 타입별 버튼 설정
    /// - Parameter type: PPT_Button Type
    func setUpButtonType(type: TYPEButton) {
        self.backgroundColor = type.backGroundColor
        self.contentsLabel.textColor = type.contentsColor
    }
}
