//
//  UIView+.swift
//  PopPool
//
//  Created by Porori on 7/2/24.
//

import Foundation
import UIKit

extension UIView {
    func showToolTip(color: ToolTipViewCPNT.TipColor, direction: ToolTipViewCPNT.TipDirection, text: String? = "최근에 이 방법으로 로그인했어요") {
        // 호출하는 컴포넌트 위 또는 아래에 생성되기 위해 superview를 구합니다
        guard let superview = self.superview else { return }
        
        let toolTip = ToolTipViewCPNT(colorType: color, direction: direction, text: text)
        
        print("상위 중앙 값", superview.bounds.width / 2)
        print("상위 프레임 값", superview.frame.width)
        superview.addSubview(toolTip)
        toolTip.snp.makeConstraints { make in
            if direction == .pointDown {
                make.bottom.equalTo(self.snp.top).offset(-8)
                make.centerX.equalToSuperview()
            } else {
                make.top.equalTo(self.snp.bottom).offset(8)
                make.centerX.equalToSuperview()
            }
        }
    }
}
