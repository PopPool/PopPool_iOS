//
//  Factory.swift
//  PopPool
//
//  Created by Porori on 6/28/24.
//

import Foundation
import UIKit
import SnapKit

class SpacingFactory {
    static let shared = SpacingFactory()
    private init() {}
    
    func createSpace(on superview: UIView, size: Int) -> UIView {
        let spacer = UIView()
        superview.addSubview(spacer)
        
        spacer.snp.makeConstraints { make in
            make.height.equalTo(size)
        }
        return spacer
    }
}
