//
//  AdminManagementListTableViewCell.swift
//  PopPool
//
//  Created by SeoJunYoung on 9/9/24.
//

import UIKit

import SnapKit

final class AdminManagementListTableViewCell: UITableViewCell {
    let popUpImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "defaultLogo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "text"
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "text"
        return label
    }()

    let titleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraint() {
        addSubview(popUpImageView)
        popUpImageView.snp.makeConstraints { make in
            make.size.equalTo(60).priority(.high)
            make.leading.top.bottom.equalToSuperview().inset(20)
        }
        
        addSubview(titleStackView)
        titleStackView.snp.makeConstraints { make in
            make.leading.equalTo(popUpImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subTitleLabel)
    }
}

extension AdminManagementListTableViewCell: CellInputable {
    struct Input {
        var image: UIImage?
        var title: String?
        var category: String?
    }
    
    func injectionWith(input: Input) {
        popUpImageView.image = input.image
        titleLabel.text = input.title
        subTitleLabel.text = input.category
    }
}
