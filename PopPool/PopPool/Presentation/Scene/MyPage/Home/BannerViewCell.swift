//
//  HeaderViewCell.swift
//  PopPool
//
//  Created by Porori on 8/17/24.
//

import UIKit
import SnapKit

final class BannerViewCell: UICollectionReusableView {
    
    static let reuseIdentifer = "HeaderViewCell"
    
    // MARK: - Components
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lasso")
        return imageView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setUpConstraint() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
