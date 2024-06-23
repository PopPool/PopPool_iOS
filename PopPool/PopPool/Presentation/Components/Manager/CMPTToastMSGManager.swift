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

class CMPTToastMSG {
    
    /// 현재 디바이스 최상단 Window를 지정
    private var window: UIWindow? {
        return UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
            
            // 아래 형식의 코드는 불가능
            // .flatMap{ ($0 as? UIWindow)?.screen ?? [] }.first { $0.isKeyWindow }
    }
    
    func createToast(message: String) {
        
        let backView = UIView()
        backView.backgroundColor = .systemTeal
        backView.layer.cornerRadius = 30
        backView.layer.shadowRadius = 4
        backView.layer.shadowOpacity = 0.4
        backView.layer.shadowOffset = CGSize(width: 0, height: 3)
        backView.translatesAutoresizingMaskIntoConstraints = false
        
        let toast = UILabel()
        toast.text = message
        toast.textAlignment = .center
        toast.font = UIFont.systemFont(ofSize: 18)
        toast.textColor = .black
        toast.numberOfLines = 0
        toast.translatesAutoresizingMaskIntoConstraints = false
        
        let textSize = toast.intrinsicContentSize
        let toastWidth = UIScreen.main.bounds.width / 9 * 7
        let labelHeight = (textSize.width / toastWidth) * 50
        let height = max(labelHeight, 60)
        
        window?.addSubview(backView)
        backView.snp.makeConstraints { make in
            if let window = window {
                make.top.equalTo(window.safeAreaLayoutGuide.snp.top).offset(20)
                make.centerX.equalTo(window.snp.centerX)
            }
            make.width.equalTo(toastWidth)
            make.height.equalTo(height)
        }
        
        backView.addSubview(toast)
        toast.snp.makeConstraints { make in
            make.centerX.equalTo(backView.snp.centerX)
            make.trailing.equalTo(backView.snp.trailing).inset(-8)
        }
        
        UIView.animate(
            withDuration: 10.0,
            delay: 3,
            options: .curveEaseOut
        ) {
            backView.alpha = 0
        } completion: { _ in
            backView.removeFromSuperview()
        }
    }
}
