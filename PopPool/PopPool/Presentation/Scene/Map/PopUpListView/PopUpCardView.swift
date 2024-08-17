//  PopUpCardView.swift
//  PopPool
//
//  Created by 김기현 on 8/8/24.
//

import UIKit
import SnapKit

class PopupCardView: UIView {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let addressLabel = UILabel()
    private let dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 4

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(categoryLabel)
        addSubview(addressLabel)
        addSubview(dateLabel)

        imageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(12)
            make.width.equalTo(76)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)

        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }
        categoryLabel.font = .systemFont(ofSize: 12)
        categoryLabel.textColor = .gray

        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }
        addressLabel.font = .systemFont(ofSize: 12)
        addressLabel.textColor = .gray

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalTo(titleLabel)
        }
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .gray
    }

    func configure(with store: PopUpStore) {
        // imageView.image = UIImage(named: store.imageName) // 이미지 로딩 로직 필요
        titleLabel.text = store.name
        categoryLabel.text = store.categories.joined(separator: ", ")
        addressLabel.text = store.address
        dateLabel.text = store.dateRange
    }
}
