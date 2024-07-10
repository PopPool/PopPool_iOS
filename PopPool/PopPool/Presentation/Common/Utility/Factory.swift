//
//  Factory.swift
//  PopPool
//
//  Created by Porori on 6/28/24.
//

import Foundation
import UIKit
import SnapKit

struct SpacingFactory {
    
    static func createSpace(size: Int) -> UIView {
        let spacer = UIView()
        spacer.snp.makeConstraints { make in
            make.height.equalTo(size)
        }
        return spacer
    }
}
