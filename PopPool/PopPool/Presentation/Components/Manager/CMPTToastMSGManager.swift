//
//  CMPTToastMSGManager.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/20/24.
//

import Foundation
import UIKit
import SnapKit

class CMPTToastMSGManager {
    
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
    
    // 화면위에 올리고
    // 새로 받는 정보로 업데이트
    // 화면에서 사라져야함
    
    private func setup(on superview: UIView) {
        superview.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            // 화면 하단에 뜰 예정
            // 화면 leading, trailing, bottom이 필요할 것
            // 특정 길이를 제공하면... 텍스트 크기에 따라 바뀌는 값을 적용할 수 없을수도 있을테니 일단 기초 공사만
            
            messageLabel.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -120),
            messageLabel.widthAnchor.constraint(equalToConstant: 180),
            messageLabel.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    private func updateMessage(message: String) {
        messageLabel.text = message
    }
    
    func createToastMSG(on superView: UIView, message: String) {
        setup(on: superView)
        updateMessage(message: message)
        
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: 4.0,
                delay: 3.0,
                options: .curveEaseOut) {
                    self.messageLabel.alpha = 0
                } completion: { complete in
                    self.messageLabel.removeFromSuperview()
                }
        }
    }
}
