//
//  BalloonBackgroundView.swift
//  PopPool
//
//  Created by 김기현 on 8/10/24.
//

import UIKit
import SnapKit

final class BalloonBackgroundView: UIView {

    enum ArrowDirection {
        case up
        case down
    }

    private let arrowHeight: CGFloat = 10.0
    private let cornerRadius: CGFloat = 12.0
    private let arrowWidth: CGFloat = 20.0

    var arrowDirection: ArrowDirection = .up {
        didSet {
            setNeedsDisplay()
        }
    }

    var arrowPosition: CGFloat = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = UIBezierPath()

        if arrowDirection == .up {
            drawUpArrow(path: path, rect: rect)
        } else {
            drawDownArrow(path: path, rect: rect)
        }

        path.close()

        UIColor.white.setFill()
        path.fill()

        // Optional: Add shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
    }

    private func drawUpArrow(path: UIBezierPath, rect: CGRect) {
        // Rounded rectangle
        path.move(to: CGPoint(x: cornerRadius, y: arrowHeight))
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: arrowHeight))
        path.addArc(withCenter: CGPoint(x: rect.width - cornerRadius, y: arrowHeight + cornerRadius), radius: cornerRadius, startAngle: CGFloat(3 * Double.pi / 2), endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))
        path.addArc(withCenter: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.height))
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: rect.height - cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
        path.addLine(to: CGPoint(x: 0, y: arrowHeight + cornerRadius))
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: arrowHeight + cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)

        // Arrow
        let arrowXPosition = rect.width * arrowPosition
        path.move(to: CGPoint(x: arrowXPosition - arrowWidth / 2, y: arrowHeight))
        path.addLine(to: CGPoint(x: arrowXPosition, y: 0))
        path.addLine(to: CGPoint(x: arrowXPosition + arrowWidth / 2, y: arrowHeight))
    }

    private func drawDownArrow(path: UIBezierPath, rect: CGRect) {
        // Rounded rectangle
        path.move(to: CGPoint(x: cornerRadius, y: 0))
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
        path.addArc(withCenter: CGPoint(x: rect.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat(3 * Double.pi / 2), endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius - arrowHeight))
        path.addArc(withCenter: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius - arrowHeight), radius: cornerRadius, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.height - arrowHeight))
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: rect.height - cornerRadius - arrowHeight), radius: cornerRadius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)

        // Arrow
        let arrowXPosition = rect.width * arrowPosition
        path.move(to: CGPoint(x: arrowXPosition - arrowWidth / 2, y: rect.height - arrowHeight))
        path.addLine(to: CGPoint(x: arrowXPosition, y: rect.height))
        path.addLine(to: CGPoint(x: arrowXPosition + arrowWidth / 2, y: rect.height - arrowHeight))
    }
}
