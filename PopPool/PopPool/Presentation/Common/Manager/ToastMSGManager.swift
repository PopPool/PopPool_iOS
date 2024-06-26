//
//  ToastMSGManager.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/20/24.
//

import Foundation
import UIKit
import SnapKit


import Foundation
import UIKit
import SnapKit

final class ToastMSGManager {
    
    // MARK: - Properties
    
    /// 현재 디바이스 최상단 Window를 지정
    static var window: UIWindow? {
        return UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
}

extension ToastMSGManager {
    
    // MARK: - Method
    
    /// 토스트 메시지를 생성하는 메서드
    /// - Parameter message: 토스트 메세지에 담길 String 타입
   static func createToast(message: String) {
        let toastMSG = CMPTToastMSG(message: message)
        window?.addSubview(toastMSG)
        
        toastMSG.snp.makeConstraints { make in
            if let window = window {
                make.bottom.equalTo(window.snp.bottom).inset(120)
                make.centerX.equalTo(window.snp.centerX)
            }
        }
        
        UIView.animate(
            withDuration: 4.0,
            delay: 3,
            options: .curveEaseOut
        ) {
            toastMSG.alpha = 0
        } completion: { _ in
            toastMSG.removeFromSuperview()
        }
    }
}
