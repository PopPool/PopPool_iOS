//
//  CoverView.swift
//  PopPool
//
//  Created by Porori on 10/9/24.
//

import UIKit
import RxSwift
import SnapKit

class CoverView: UIView {
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(actionButton)
        stack.contentMode = .center
        return stack
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .w70
        label.textAlignment = .center
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        let text = "재오픈 알림받기"
        let attributeText = NSMutableAttributedString(string: text)
        attributeText.addAttribute(.foregroundColor, value: UIColor.w100, range: NSRange(location: 0, length: text.count))
        attributeText.addAttribute(.underlineStyle, value: 1, range: NSRange(location: 0, length: text.count))
        button.setAttributedTitle(attributeText, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        stack.axis = .vertical
        stack.spacing = 12
        
        label.text = "팝업이 종료되었어요"
        label.font = .KorFont(style: .bold, size: 16)
    }
    
    func setUpConstraint() {
        self.addSubview(stack)
        
        label.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        
        actionButton.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        stack.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
