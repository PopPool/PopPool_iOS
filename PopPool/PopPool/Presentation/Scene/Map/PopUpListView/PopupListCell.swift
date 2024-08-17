//  PopupListCell.swift
//  PopPool
//
//  Created by 김기현 on 8/8/24.
//

import UIKit
import SnapKit

class PopupListCell: UITableViewCell {

    private let popupImageView = UIImageView()
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let addressLabel = UILabel()
    private let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(popupImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(dateLabel)

        popupImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(popupImageView.snp.trailing).offset(8)
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }

        categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.trailing.equalTo(nameLabel)
        }

        addressLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(categoryLabel.snp.bottom).offset(4)
            make.trailing.equalTo(nameLabel)
        }

        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(addressLabel.snp.bottom).offset(4)
            make.trailing.equalTo(nameLabel)
            make.bottom.equalToSuperview().offset(-8)
        }
    }

    func configure(with store: PopUpStore) {
        nameLabel.text = store.name
        categoryLabel.text = store.categories.joined(separator: ", ")
        addressLabel.text = store.address
        dateLabel.text = store.dateRange
        popupImageView.image = UIImage(named: "exampleImage") // 임시 이미지, 실제 데이터로 교체 필요
    }
}
