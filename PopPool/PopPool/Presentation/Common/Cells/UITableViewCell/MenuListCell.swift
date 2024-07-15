//
//  MenuListCell.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/10/24.
//

import UIKit
import SnapKit

struct MenuListCellSection: TableViewSectionable {
    
    struct Input {
        var sectionTitle: String?
    }
    
    struct Output {
    }
    
    typealias CellType = MenuListCell
    
    var sectionInput: Input

    var sectionCellInputList: [MenuListCell.Input]

    func makeHeaderView() -> UIView? {
        let containerView = UIView()
        let titleView = ListTitleViewCPNT(title: sectionInput.sectionTitle, size: .medium)
        titleView.titleLabel.font = .KorFont(style: .bold, size: 16)
        titleView.rightButton.isHidden = true
        let topView = UIView()
        containerView.backgroundColor = .systemBackground
        topView.backgroundColor = .g50

        containerView.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.spaceGuide.small100)
        }
        if sectionInput.sectionTitle != nil {
            containerView.addSubview(titleView)
            titleView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(20)
                make.top.equalTo(topView.snp.bottom).offset(Constants.spaceGuide.small400)
                make.bottom.equalToSuperview().inset(Constants.spaceGuide.small400)
            }
        } else {
            topView.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(Constants.spaceGuide.small400)
            }
        }
        return containerView
    }
    
    func sectionOutput() -> Output {
        return Output()
    }
    
    func makeFooterView() -> UIView? {
        return nil
    }
}

final class MenuListCell: UITableViewCell {
    
    // MARK: - Components
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 15)
        return label
    }()
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 13)
        return label
    }()
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "line_signUp")
        return view
    }()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension MenuListCell {
    func setUp() {
        
    }
    
    func setUpConstraints() {
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constants.spaceGuide.small100)
            make.leading.equalToSuperview().inset(22)
            make.trailing.equalToSuperview().inset(18)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(23)
        }
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(23)
        }
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(subTitleLabel)
        contentStackView.addArrangedSubview(iconImageView)
    }
}

// MARK: - Methods
extension MenuListCell: Cellable {
    
    struct Output {
        
    }
    
    
    struct Input {
        var title: String?
        var subTitle: String?
        var subTitleColor: UIColor?
    }
    
    func injectionWith(input: Input) {
        titleLabel.text = input.title
        subTitleLabel.text = input.subTitle
        subTitleLabel.textColor = input.subTitleColor
    }
    
    func getOutput() -> Output {
        return Output()
    }
}
