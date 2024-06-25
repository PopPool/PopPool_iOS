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
    
    enum ToolTipDirection {
        case notifyAbove
        case notifyBelow
    }
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .w100
        label.text = "최근에 이 방법으로 로그인했어요"
        label.font = .KorFont(style: .medium, size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fixedWidth: CGFloat = 219
    private let padding: CGFloat = 10
    private var direction: ToolTipDirection
    
    init(frame: CGRect, direction: ToolTipDirection) {
        self.direction = direction
        super.init(frame: .zero)
        backgroundColor = .clear
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawToolTip()
    }
}

extension CMPTToolTipView {
    
    private func setupLayer() {
        addSubview(notificationLabel)
        
        switch direction {
        case .notifyAbove:
            notificationLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().inset(7)
            }
        case .notifyBelow:
            notificationLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.top.equalToSuperview().inset(8)
            }
        }
    }
    
    private func drawToolTip() {
        switch direction {
        case .notifyAbove:
            drawAboveToolTip()
        case .notifyBelow:
            drawInverseToolTip()
        }
    }
    
    private func drawInverseToolTip() {
        let tip = UIBezierPath()
        tip.move(to: CGPoint(x: (fixedWidth/2)-8, y: 35))
        tip.addLine(to: CGPoint(x: fixedWidth/2, y: 45))
        tip.addLine(to: CGPoint(x: (fixedWidth/2) + 8, y: 35))
        tip.close()
        
        UIColor.blu500.setFill()
        tip.fill()
        
        let message = UIBezierPath(
            roundedRect: CGRect(
                x: 0, y: 0,
                width: fixedWidth,
                height: 35
            ),
            cornerRadius: 4
        )
        
        UIColor.blu500.setFill()
        message.fill()
    }
    
    private func drawAboveToolTip() {
        let tip = UIBezierPath()
        tip.move(to: CGPoint(x: (fixedWidth/2)-8, y: padding))
        tip.addLine(to: CGPoint(x: fixedWidth/2, y: 0))
        tip.addLine(to: CGPoint(x: (fixedWidth/2) + 8, y: padding))
        tip.close()
        
        UIColor.blu500.setFill()
        tip.fill()
        
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
