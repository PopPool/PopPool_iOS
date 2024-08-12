////
////  CategoryCell.swift
////  PopPool
////
////  Created by 김기현 on 8/12/24.
////
//
//import UIKit
//
//class CategoryCell: UICollectionViewCell {
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 14)
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupUI() {
//        contentView.addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        contentView.layer.cornerRadius = 20
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.lightGray.cgColor
//    }
//
//    func configure(with title: String) {
//        titleLabel.text = title
//        updateAppearance()
//    }
//
//    func toggleSelection() {
//        isSelected.toggle()
//        updateAppearance()
//    }
//
//    private func updateAppearance() {
//        if isSelected {
//            contentView.backgroundColor = .blue
//            titleLabel.textColor = .white
//        } else {
//            contentView.backgroundColor = .white
//            titleLabel.textColor = .black
//        }
//    }
//}
