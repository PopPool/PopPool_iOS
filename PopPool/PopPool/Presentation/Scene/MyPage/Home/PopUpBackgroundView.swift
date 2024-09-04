//
//  PopUpBackgroundView.swift
//  PopPool
//
//  Created by Porori on 8/18/24.
//

import UIKit

final class PopUpBackgroundView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let reuseIdentifer = "PopUpBackgroundView"
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .g700
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
