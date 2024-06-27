//
//  HeaderViewCPNT.swift
//  PopPool
//
//  Created by Porori on 6/26/24.
//

import Foundation
import UIKit
import SnapKit

class HeaderViewCPNT: UIStackView {
    
    enum Style {
        case icon
        case text
    }
    
    let backButton: UIButton = {
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
    
    let iconButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.g1000, for: .normal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()
    
    init(title: String, style: Style) {
        super.init(frame: .zero)
        setupLayout()
        setupViews(title: title, style: style)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.axis = .horizontal
        self.distribution = .fillProportionally
        self.spacing = 10
        
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 16)
        
        self.addArrangedSubview(backButton)
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(iconButton)
    }
    
    private func setupViews(title: String, style: Style) {
        
        titleLabel.text = title
        switch style {
        case .icon:
            backButton.setImage(.icoLine, for: .normal)
            iconButton.setImage(.icoSolid, for: .normal)
        case .text:
            backButton.setImage(.icoLine, for: .normal)
            iconButton.setTitle("둘러보기", for: .normal)
            iconButton.titleLabel?.font = .KorFont(style: .regular, size: 14)
        }
    }
}
