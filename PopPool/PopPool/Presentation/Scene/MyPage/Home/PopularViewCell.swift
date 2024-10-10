//
//  InterestViewCell.swift
//  PopPool
//
//  Created by Porori on 8/18/24.
//

import UIKit
import SnapKit
import RxSwift

final class PopularViewCell: UICollectionViewCell {
    
    // MARK: - Component
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let containerView = UIView()
    private let disposeBag = DisposeBag()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(descriptionLabel)
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let service = PreSignedService()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = nil
        titleLabel.text = nil
        imageView.image = UIImage(systemName: "photo")
    }
    
    // MARK: - Methods
    
    public func configure(title: String, category: String, image: UIImage?) {
        titleLabel.text = title
        descriptionLabel.text = category
        imageView.image = image
    }
    
    private func setUp() {
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        titleLabel.textColor = .w100
        descriptionLabel.textColor = .w100
    }
    
    private func setUpConstraint() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(332)
        }
        imageView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        
        containerView.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension PopularViewCell: Cellable {
    
    struct Input {
        var image: String?
        var category: String?
        var title: String?
        var location: String?
        var date: String?
    }
    
    struct Output {
        
    }
    
    /// 맞춤 관심 역할을 하는 cell에 데이터를 주입하는 메서드
    /// - Parameter input: Input 값을 받습니다
    func injectionWith(input: Input) {
        imageView.image = UIImage(named: "defaultLogo")
        
        if let path = input.image,
           //           let date = input.date,
           let location = input.location,
           let category = input.category,
           let description = input.title {
            
            let value = "#\(category)"
            let text = "#\(input.date)까지 열리는\n#\(category) #\(location)"
            let attributedString = NSMutableAttributedString(string: text)
            let range = (text as NSString).range(of: value)
            
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = 1.4
            attributedString.addAttributes([
                .backgroundColor: UIColor.white,
                .foregroundColor: UIColor.black
            ], range: range)
            attributedString.addAttribute(.paragraphStyle,
                                          value: style,
                                          range: NSRange(location: 0, length: text.count))
            
            let titleAttribute = NSMutableAttributedString(string: description)
            titleAttribute.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: description.count))
            
            titleLabel.attributedText = attributedString
            descriptionLabel.attributedText = titleAttribute
            //
            //            service.tryDownload(filePaths: [path])
            //                .subscribe { [weak self] images in
            //                    guard let image = images.first else { return }
            //                    self?.imageView.image = image
            //                } onFailure: { [weak self] error in
            //                    self?.imageView.image = UIImage(named: "defaultLogo")
            //                    print("ImageDownLoad Fail")
            //                }
            //                .disposed(by: disposeBag)
        }
    }
    
    func getOutput() -> Output {
        return Output()
    }
}
