//
//  TestingHomeCollectionViewCell.swift
//  PopPool
//
//  Created by Porori on 8/17/24.
//

import UIKit
import SnapKit
import RxSwift

final class TestingHomeCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lasso")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTitle()
    }
    
    func setImage(image: UIImage?) {
        self.imageView.image = image
    }
    
    private func layoutTitle() {
        if !self.contentView.subviews.contains(imageView) {
            self.contentView.addSubview(imageView)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.edges.equalToSuperview()
        }
    }
}
