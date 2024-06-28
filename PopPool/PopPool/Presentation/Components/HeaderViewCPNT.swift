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
        case icon(UIImage?)
        case text(String)
    }
    
    // MARK: - Properties
    
    let leftBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .g1000
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
        return button
    }()
    
    private let leftTrailingView = UIView()
    private let centerTrailingView = UIView()
    private let rightTrailingView = UIView()
    
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
        self.distribution = .fillEqually
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 16)
        
        leftTrailingView.addSubview(leftBarButton)
        centerTrailingView.addSubview(titleLabel)
        rightTrailingView.addSubview(rightBarButton)
        
        leftBarButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        rightBarButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
        }
        self.addArrangedSubview(leftTrailingView)
        self.addArrangedSubview(centerTrailingView)
        self.addArrangedSubview(rightTrailingView)

    }
    
    /// 헤더 뷰의 컴포넌트 설정
    /// - Parameters:
    ///   - title: 바꿀 제목명을 받습니다
    ///   - style: rightBarButton의 아이콘 타입 (ie. text / icon)
    private func setupViews(title: String, style: Style) {
        leftBarButton.setImage(UIImage(named: "icoLine"), for: .normal)
        
        switch style {
        case .icon(let image):
            rightBarButton.setImage(image!.withTintColor(.g1000, renderingMode: .alwaysOriginal), for: .normal)
        case .text(let buttonText):
            rightBarButton.setTitle(buttonText, for: .normal)
            rightBarButton.titleLabel?.font = .KorFont(style: .regular, size: 14)
        }
        titleLabel.text = title
    }

}
