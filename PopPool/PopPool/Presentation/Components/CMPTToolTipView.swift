//
//  CMPTToolTip.swift
//  PopPool
//
//  Created by Porori on 6/25/24.
//

import Foundation
import UIKit
import SnapKit

class CMPTToolTipView: UIView {
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .w100
        label.text = "최근에 이 방법으로 로그인했어요"
        label.font = .KorFont(style: .medium, size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fixedWidth: CGFloat = 219
    let padding: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // 툴팁의 팁 부분 생성
        drawTip()
        
        // 툴팁의 메시지 부분 생성
        drawMessage()
    }
}

extension CMPTToolTipView {
    
    private func setupLayer() {
        addSubview(notificationLabel)
        notificationLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func setupInverseLayer() {
        addSubview(notificationLabel)
        notificationLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
        }
    }
    
    private func drawTip() {
        let tip = UIBezierPath()
        tip.move(to: CGPoint(x: (fixedWidth/2)-8, y: padding))
        tip.addLine(to: CGPoint(x: fixedWidth/2, y: 0))
        tip.addLine(to: CGPoint(x: (fixedWidth/2) + 8, y: padding))
        tip.close()
        
        UIColor.blu500.setFill()
        tip.fill()
    }
    
    private func drawMessage() {
        let message = UIBezierPath(
            roundedRect: CGRect(
                x: 0, y: 10,
                width: fixedWidth,
                height: 35
            ),
            cornerRadius: 4
        )
        
        UIColor.blu500.setFill()
        message.fill()
    }
}
