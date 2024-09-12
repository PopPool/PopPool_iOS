//
//  InstagramFirstView.swift
//  PopPool
//
//  Created by Porori on 9/12/24.
//

import Foundation
import UIKit
import SnapKit

final class InstagramView: UIStackView {
    
    private let topSpaceView = UIView()
    private let numberView = UIView()
    private let numberText = UILabel()
    private let middleSpaceView = UIView()
    private let bottomSpaceView = UIView()
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        return title
    }()
    
    init() {
        super.init(frame: .zero)
        setUp()
        setTitle()
        setUpConstraint()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTitle() {
        let fullText = "아래 인스타그램 열기\n버튼을 터치해 앱 열기"
        let attributedText = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "인스타그램 열기")
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.4
        
        attributedText
            .addAttribute(.foregroundColor,
                          value: UIColor.blu500,
                          range: range)
        attributedText
            .addAttribute(.paragraphStyle,
                          value: style,
                          range: NSRange(
                            location: 0,
                            length: attributedText.length))
        
        titleLabel.attributedText = attributedText
        titleLabel.font = .KorFont(style: .bold, size: 20)
    }
    
    private func setUp() {
        self.axis = .vertical
        self.alignment = .leading
        
        numberView.layer.cornerRadius = 4
        numberView.backgroundColor = .g900
        numberText.text = "#1"
        numberText.textColor = .w100
        numberText.font = .KorFont(style: .bold, size: 16)
        
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.4
        
        let attributedText = NSMutableAttributedString(string: numberText.text ?? "")
        attributedText
            .addAttribute(.paragraphStyle,
                          value: style,
                          range: NSRange(
                            location: 0,
                            length: attributedText.length))
    }
    
    private func setUpConstraint() {
        self.addArrangedSubview(topSpaceView)
        self.addArrangedSubview(numberView)
        numberView.addSubview(numberText)
        
        self.addArrangedSubview(middleSpaceView)
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(bottomSpaceView)
        
        topSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.medium200)
        }
        
        numberView.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(33)
        }
        
        numberText.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        middleSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small100)
        }
        
        bottomSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small400)
        }
    }
    
    public func updateView(number: Int, title: String?) {
        let text = "#\(number)"
        let numberAttr = NSAttributedString(string: text)
        let titleAttr = NSAttributedString(string: title ?? "")
        numberText.attributedText = numberAttr
        titleLabel.attributedText = titleAttr
    }
}
