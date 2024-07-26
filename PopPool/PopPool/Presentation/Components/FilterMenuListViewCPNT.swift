//
//  FilterMenuListViewCPNT.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/26/24.
//

import UIKit
import SnapKit

final class FilterMenuListViewCPNT: UIView {
    
    // MARK: - Components
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 13)
        label.textColor = .g400
        return label
    }()
    private let filterStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 6
        return view
    }()
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 13)
        label.textColor = .g1000
        return label
    }()
    private let filterImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bottomArrow_signUp")
        return view
    }()
    let filterButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    init(_ input: Input) {
        super.init(frame: .zero)
        setUpConstraints()
        injectionWith(input: input)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension FilterMenuListViewCPNT {
    
    func setUpConstraints() {
        filterImageView.snp.makeConstraints { make in
            make.size.equalTo(22)
        }
        filterStackView.addArrangedSubview(filterLabel)
        filterStackView.addArrangedSubview(filterImageView)
        self.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(22)
            make.trailing.equalToSuperview().inset(18)
            make.top.bottom.equalToSuperview().inset(Constants.spaceGuide.small100)
        }
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(filterStackView)
        filterStackView.addSubview(filterButton)
        filterButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - InputableView
extension FilterMenuListViewCPNT: InputableView {
    
    struct Input {
        var title: String
        var filterTitle: String
    }
    
    func injectionWith(input: Input) {
        titleLabel.text = input.title
        filterLabel.text = input.filterTitle
    }
}
