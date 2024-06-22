//
//  CMPTToastMSGManager.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/20/24.
//

import Foundation
import UIKit
import SnapKit

final class CMPTToastMSGManager {
    
    static let shared = CMPTToastMSGManager()
    private init() {}
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

extension CMPTToastMSGManager {
    
    /// toastMessage의 화면 구현 메서드
    /// - Parameter superview: 현재 화면
    private func setup(on superview: UIView) {
        superview.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -120),
            messageLabel.widthAnchor.constraint(equalToConstant: 180),
            messageLabel.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    /// toastMessage의 메시지 업데이트 메서드
    /// - Parameter message: String 타입의 메시지를 받습니다
    private func updateMessage(message: String) {
        messageLabel.text = message
    }
    
    /// ToastMessage를 특정 화면에 올리는 메서드
    /// - Parameters:
    ///   - superView: 현재 사용하는 화면
    ///   - message: String 타입의 메시지를 받습니다
    func createToastMSG(on superView: UIView, message: String) {
        setup(on: superView)
        updateMessage(message: message)
        
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: 4.0,
                delay: 3.0,
                options: .curveEaseOut
            ) {
                // 에니메이션 효과
                self.messageLabel.alpha = 0
            } completion: { complete in
                // 에니메이션 종료 이후 메모리에서 사라집니다
                self.messageLabel.removeFromSuperview()
            }
        }
    }
}
