//
//  ListMenuCPNT.swift
//  PopPool
//
//  Created by Porori on 7/22/24.
//

import UIKit
import RxSwift
import SnapKit

class ListMenuCPNT: UIStackView {
    
    enum MenuOption {
        case none
        case menu
        case filter(UIImage?)
    }
    
    // 타이틀
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 15)
        return label
    }()
    
    // 서브 버튼 텍스트
    let optionTitle: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 13)
        return label
    }()
    
    let icon: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let topSpaceView = UIView()
    let bottomSpaceView = UIView()
    
    lazy var titleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.backgroundColor = .green
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(optionTitle)
        stack.addArrangedSubview(icon)
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 18)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    init(menuTitle: String, style: MenuOption) {
        self.titleLabel.text = menuTitle
        super.init(frame: .zero)
        setUp()
        setUpConstraints()
        setStyle(title: menuTitle, style: style)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        self.axis = .vertical
        topSpaceView.backgroundColor = .yellow
        bottomSpaceView.backgroundColor = .yellow
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
        
        icon.snp.makeConstraints { make in
            make.size.equalTo(22)
        }
    }
    
    private func setStyle(title: String, style: MenuOption) {
        titleLabel.text = title
        icon.setImage(UIImage(named: "line_signUp"), for: .normal)
        
        switch style {
        case .filter(let image):
            optionTitle.text = "필터옵션"
            icon.setImage(image, for: .normal)
        case .menu:
            optionTitle.text = "메뉴정보"
            optionTitle.textColor = .blu500
        case .none:
            optionTitle.text = ""
        }
    }
}
