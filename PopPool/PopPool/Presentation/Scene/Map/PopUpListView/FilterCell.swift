//
//  FilterCell.swift
//  PopPool
//
//  Created by 김기현 on 8/8/24.
//

import UIKit
import SnapKit

class FilterCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let removeButton = UIButton(type: .system)
    var onRemove: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .systemBlue

        // 버튼 스타일을 변경하여 파란색 테두리를 추가
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .white // 배경을 흰색으로 설정

        contentView.addSubview(titleLabel)
        contentView.addSubview(removeButton)

        titleLabel.sizeToFit()
        removeButton.sizeToFit()

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }

        removeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }

        removeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        removeButton.tintColor = .black
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }

    func configure(with title: String) {
        titleLabel.text = title
    }

    @objc private func removeButtonTapped() {
        onRemove?()
    }
}
