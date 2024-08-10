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
    private let cancelButton = UIButton(type: .system)

    var onRemove: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(cancelButton)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }

        cancelButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }

        contentView.backgroundColor = .systemBlue
        contentView.layer.cornerRadius = 15

        titleLabel.textColor = .white
        cancelButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        cancelButton.tintColor = .white

        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }

    func configure(with title: String) {
        titleLabel.text = title
    }

    @objc private func cancelButtonTapped() {
        onRemove?()
    }
}
