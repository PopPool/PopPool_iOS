//
//  CMPTToastMSGManager.swift
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

class CMPTToastMSGManager {
    
    /// 현재 디바이스 최상단 Window를 지정
    private var window: UIWindow? {
        return UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
    
    func createToast(message: String) {
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
