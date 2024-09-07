//
//  UICollectionReusableView.swift
//  PopPool
//
//  Created by Porori on 9/7/24.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
