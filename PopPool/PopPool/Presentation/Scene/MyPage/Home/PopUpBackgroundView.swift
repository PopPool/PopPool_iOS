//
//  PopUpBackgroundView.swift
//  PopPool
//
//  Created by Porori on 8/18/24.
//

import UIKit

class PopUpBackgroundView: UICollectionReusableView {
    
    static let reuseIdentifer = "PopUpBackgroundView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
