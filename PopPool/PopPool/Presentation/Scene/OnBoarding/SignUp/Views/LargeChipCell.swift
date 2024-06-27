//
//  LargeChipCell.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/27/24.
//

import UIKit
import SnapKit

final class LargeChipCell: UICollectionViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .bold, size: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.transition(with: self.contentView, duration: 0.2, options: .transitionCrossDissolve) {
                self.contentView.layer.borderWidth = self.isSelected ? 0 : 1
                self.contentView.layer.borderColor = self.isSelected ? nil : UIColor.g200.cgColor
                self.contentView.backgroundColor = self.isSelected ? .blu500 : .clear
                self.label.textColor = self.isSelected ? .w100 : .g400
            }
        }
    }
}

extension LargeChipCell {
    
    func setUp() {
        self.contentView.layer.cornerRadius = contentView.frame.height / 2
        self.contentView.layer.borderWidth = self.isSelected ? 0 : 1
        self.contentView.layer.borderColor = self.isSelected ? nil : UIColor.g200.cgColor
        self.contentView.backgroundColor = self.isSelected ? .blu500 : .clear
        self.label.textColor = self.isSelected ? .w100 : .g400
    }
    
    func setUpConstraints() {
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.leading.trailing.equalToSuperview().inset(Constants.spaceGuide._16px)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(9)
        }
    }
    
    func configure(title: String?) {
        label.text = title
    }
    
    func adjustCellSize(title: String) -> CGSize {
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: UIView.layoutFittingCompressedSize.height)
        return self.contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority:.fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}
