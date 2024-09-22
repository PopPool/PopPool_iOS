//
//  AdminImageViewCollectionViewCell.swift
//  PopPool
//
//  Created by SeoJunYoung on 9/9/24.
//

import UIKit

import SnapKit
import RxSwift

final class AdminImageViewCollectionViewCell: UICollectionViewCell {
    
    let checkBox: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "square")
        return view
    }()
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .blue
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.addSubview(checkBox)
        checkBox.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.trailing.top.equalToSuperview().inset(5)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                checkBox.image = UIImage(systemName: "checkmark.square.fill")
            } else {
                checkBox.image = UIImage(systemName: "square")
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AdminImageViewCollectionViewCell: CellInputable {
    struct Input {
        let image: UIImage?
    }
    
    func injectionWith(input: Input) {
        imageView.image = input.image
    }
}
