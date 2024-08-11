//
//  GridLayout.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/27/24.
//

import UIKit

class GridLayout: UICollectionViewFlowLayout {
    init(height: CGFloat) {
        super.init()
        let width = (UIScreen.main.bounds.width - 40 - 8) / 2
        let height: CGFloat = height
        self.itemSize = .init(width: width, height: height)
        self.minimumLineSpacing = 12
        self.minimumInteritemSpacing = 8
        self.scrollDirection = .vertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
