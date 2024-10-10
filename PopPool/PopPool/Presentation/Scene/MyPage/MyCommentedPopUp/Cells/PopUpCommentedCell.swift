//
//  PopUpCommentedCell.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/11/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

final class PopUpCommentedCell: UICollectionViewCell {
    // MARK: - Components
    private let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private let popUpTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .bold, size: 11)
        label.textColor = .blu500
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .medium, size: 12)
        label.numberOfLines = 0
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .EngFont(style: .regular, size: 11)
        label.textColor = .g400
        label.textAlignment = .left
        return label
    }()
    
    private let disposeBag = DisposeBag()

    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension PopUpCommentedCell {
    func setUp() {
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
    }
    
    func setUpConstraints() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.height.equalTo(contentView.frame.width)
        }
    }
    
    func setUpNormalComment() {
        contentView.addSubview(popUpTitleLabel)
        popUpTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(16)
        }
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(popUpTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(36)
        }
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
        }
    }
    
    func setUpInstaComment() {
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(54)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
        }
    }
}

extension PopUpCommentedCell: Cellable {

    struct Input {
        var imageURL: String?
        var commentType: CommentType
        var title: String?
        var content: String
        var date: String
    }
    struct Output {
        
    }
    
    func injectionWith(input: Input) {
        let service = PreSignedService()
        if let path = input.imageURL {
            imageView.setPresignedImage(
                from: [path],
                service: service,
                bag: disposeBag)
        }
        popUpTitleLabel.text = input.title
        contentLabel.text = input.content
        dateLabel.text = input.date
        
        switch input.commentType {
        case .normal:
            setUpNormalComment()
        case .instagram:
            setUpInstaComment()
        }
    }
    
    func getOutput() -> Output {
        return Output()
    }
}
