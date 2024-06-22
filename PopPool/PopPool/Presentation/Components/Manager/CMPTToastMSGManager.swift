//
//  CMPTToastMSGView.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/20/24.
//

import Foundation
import UIKit
import SnapKit

class CMPTToastMSGManager {
    
    static let shared = CMPTToastMSGManager()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
        
    private init() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CMPTToastMSGManager {
    
    
    
    // 토스트 메시지가 화면에서 사라집니다
//    func showMessage() {
//        UIView.animate(
//            withDuration: 4.0,
//            delay: 0.1,
//            options: .curveEaseOut
//        ) { self.alpha = 0 } completion: { complete in
//            self.removeFromSuperview()
//            print("toastMessage가 화면에서 내려갔습니다")
//        }
//    }
//
//    private func setup() {
//        // 기초 설정
//        self.clipsToBounds = true
//        self.layer.cornerRadius = 4
//        self.backgroundColor = .gray
//        
//        // Layout 설정
//        addSubview(messageLabel)
//        messageLabel.snp.makeConstraints { make in
//            make.height.equalTo(38)
//            make.centerY.equalToSuperview()
//            make.leading.trailing.equalToSuperview().inset(16)
//        }
//    }
}
