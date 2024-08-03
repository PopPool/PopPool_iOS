//
//  CardListLayout.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/27/24.
//

import UIKit

class CardListLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        let width = UIScreen.main.bounds.width - 40
        let height: CGFloat = 590
        self.itemSize = .init(width: width, height: height)
        self.minimumLineSpacing = 20
        self.minimumInteritemSpacing = 0
        self.scrollDirection = .vertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
