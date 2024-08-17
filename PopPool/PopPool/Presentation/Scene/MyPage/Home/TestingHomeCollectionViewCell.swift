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
    private var title: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.contentView.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTitle()
    }
    
    func setLabel(text: String) {
        self.title.text = text
        self.title.numberOfLines = 3
    }
    
    private func layoutTitle() {
        if !self.contentView.subviews.contains(title) {
            self.contentView.addSubview(title)
        }
        
        title.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.edges.equalToSuperview()
        }
    }
}
