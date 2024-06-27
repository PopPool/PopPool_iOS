//
//  HeaderViewCPNT.swift
//  PopPool
//
//  Created by Porori on 6/26/24.
//

import Foundation
import UIKit
import SnapKit

final class HeaderViewCPNT: UIStackView {
    
    enum Style {
        case icon
        case text(String)
    }
    
    // MARK: - Properties
    
    let leftBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .g1000
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 15)
        label.textColor = .g1000
        label.textAlignment = .center
        return label
    }()
    
    let rightBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.g1000, for: .normal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()
    
    // MARK: - Initializer
    
    init(title: String, style: Style) {
        super.init(frame: .zero)
        setupLayout()
        setupViews(title: title,style: style)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeaderViewCPNT {
    
    /// 기본 헤더 뷰의 화면 구성
    private func setupLayout() {
        self.axis = .horizontal
        self.distribution = .fillProportionally
        self.spacing = 10
        
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 16)
        
        self.addArrangedSubview(leftBarButton)
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(rightBarButton)
    }
    
    /// 헤더 뷰의 컴포넌트 설정
    /// - Parameters:
    ///   - title: 바꿀 제목명을 받습니다
    ///   - style: rightBarButton의 아이콘 타입 (ie. text / icon)
    private func setupViews(title: String, style: Style) {
        
        switch style {
        case .icon:
            leftBarButton.setImage(.icoLine, for: .normal)
            rightBarButton.setImage(.icoSolid.withTintColor(.g1000, renderingMode: .alwaysOriginal), for: .normal)
        case .text(let buttonText):
            leftBarButton.setImage(.icoLine, for: .normal)
            rightBarButton.setTitle(buttonText, for: .normal)
            rightBarButton.titleLabel?.font = .KorFont(style: .regular, size: 14)
        }
        titleLabel.text = title
    }

}
