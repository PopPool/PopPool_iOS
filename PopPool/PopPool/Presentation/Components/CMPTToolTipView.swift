//
//  CMPTToolTip.swift
//  PopPool
//
//  Created by Porori on 6/25/24.
//

import Foundation
import UIKit
import SnapKit

final class CMPTToolTipView: UIView {
    
    /// 방향에 따라 툴팁을 다르게 표시합니다
    enum TipDirection {
        case pointUp
        case pointDown
    }
    
    enum TipColor {
        case blu500
        case w100
        
        var color: UIColor {
            switch self {
            case .blu500: return UIColor.blu500
            case .w100: return UIColor.w100
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .blu500: return UIColor.w100
            case .w100: return UIColor.blu500
            }
        }
    }
    
    // MARK: - Properties
    
    private let bgView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = "최근에 이 방법으로 로그인했어요"
        label.font = .KorFont(style: .medium, size: 13)
        return label
    }()
    
    private var colorType: TipColor {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private let fixedWidth: CGFloat = 219
    private var direction: TipDirection
    
    // MARK: - init
    
    init(colorType: TipColor, direction: TipDirection) {
        self.colorType = colorType
        self.direction = direction
        super.init(frame: .zero)
        setupLayer(color: colorType)
        notificationLabel.textColor = colorType.textColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawToolTip()
    }
}

extension CMPTToolTipView {
    
    // MARK: - Methods
    
    private func setupLayer(color: TipColor) {
        self.backgroundColor = .clear
        addSubview(bgView)
        
        bgView.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.bottom.equalTo(snp.bottom)
            make.top.equalTo(snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        bgView.addSubview(notificationLabel)
        switch direction {
        case .pointUp:
            notificationLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().inset(11)
            }
            
        case .pointDown:
            notificationLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.top.equalToSuperview().inset(11)
            }
        }
    }
    
    /// 툴팁을 방향에 맞춰 그립니다
    private func drawToolTip() {
        switch direction {
        case .pointUp:
            drawAboveToolTip()
            addShadow()
            
        case .pointDown:
            drawInverseToolTip()
            addShadow()
        }
    }
    
    /// 위에서 아래를 가리키는 툴팁을 만듭니다
    private func drawAboveToolTip() {
        let tip = UIBezierPath()
        tip.move(to: CGPoint(x: (fixedWidth/2)-8, y: 10))
        tip.addLine(to: CGPoint(x: fixedWidth/2, y: 0))
        tip.addLine(to: CGPoint(x: (fixedWidth/2) + 8, y: 10))
        tip.close()
        
        colorType.color.setFill()
        tip.fill()
        addMessageView()
    }
    
    /// 아래에서 위를 가리키는 툴팁을 만듭니다
    private func drawInverseToolTip() {
        let tip = UIBezierPath()
        tip.move(to: CGPoint(x: (fixedWidth/2)-8, y: 35))
        tip.addLine(to: CGPoint(x: fixedWidth/2, y: 45))
        tip.addLine(to: CGPoint(x: (fixedWidth/2) + 8, y: 35))
        tip.close()
        
        colorType.color.setFill()
        tip.fill()
        addMessageView()
    }
    
    private func addMessageView() {
        let message = UIBezierPath(
            roundedRect: CGRect(
                x: 0, y: 10,
                width: fixedWidth,
                height: 35
            ),
            cornerRadius: 4
        )
        
        colorType.color.setFill()
        message.fill()
        message.close()
    }
    
    private func addShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
