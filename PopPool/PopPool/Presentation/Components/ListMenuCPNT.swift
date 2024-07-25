//
//  ListMenuCPNT.swift
//  PopPool
//
//  Created by Porori on 7/24/24.
//

import UIKit
import SnapKit
import RxSwift

final class ListMenuCPNT: UIStackView {
    
    //MARK: - Menu Button Options
    
    enum MenuStyle {
        case none
        case menu(String)
        case filter(UIImage?)
    }
    
    //MARK: - Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 15)
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 13)
        return label
    }()
    
    private let iconButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    lazy var titleStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subTitle)
        stack.addArrangedSubview(iconButton)
        stack.spacing = 6
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 18)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private let topSpaceView = UIView()
    private let bottomSpaceView = UIView()
    
    //MARK: - Initializer
    
    init(titleText: String, style: MenuStyle) {
        self.titleLabel.text = titleText
        super.init(frame: .zero)
        setUp()
        setUpConstraints()
        setStyle(title: titleText, style: style)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Method
    
    private func setUp() {
        self.axis = .vertical
        self.titleLabel.textColor = .g1000
    }
    
    private func setUpConstraints() {
        self.addArrangedSubview(topSpaceView)
        self.addArrangedSubview(titleStack)
        self.addArrangedSubview(bottomSpaceView)
        
        topSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small100)
        }
        
        bottomSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small100)
        }
        
        iconButton.snp.makeConstraints { make in
            make.size.equalTo(22)
        }
    }
    
    /// 버튼 스타일에 따라 다른 값을 제공하는 메서드입니다
    /// - Parameters:
    ///   - title: String 타입을 받습니다
    ///   - style: MenuStyle을 받아 switch로 분기를 확인합니다
    private func setStyle(title: String, style: MenuStyle) {
        titleLabel.text = title
        iconButton.setImage(UIImage(named: "line_signUp"), for: .normal)
        titleStack.setCustomSpacing(42, after: titleLabel)
        
        switch style {
        case .filter(let image):
            subTitle.text = "필터옵션"
            subTitle.textColor = .g1000
            titleLabel.textColor = .g400
            iconButton.setImage(image, for: .normal)
            
        case .menu(let title):
            subTitle.text = title
            subTitle.textColor = .blu500
            
        case .none:
            subTitle.text = ""
        }
    }
}
