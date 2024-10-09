//
//  UIImageView+.swift
//  PopPool
//
//  Created by Porori on 10/9/24.
//

import UIKit
import RxSwift
import SnapKit

extension UIImageView {
    func setClosedNotice(date: String) {
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let cover = CoverView()
        cover.frame = self.bounds
        cover.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        self.addSubview(cover)
        
        cover.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
