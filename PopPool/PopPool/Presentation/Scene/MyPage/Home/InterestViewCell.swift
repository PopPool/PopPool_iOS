//
//  InterestViewCell.swift
//  PopPool
//
//  Created by Porori on 8/18/24.
//

import UIKit
import SnapKit
import RxSwift

final class InterestViewCell: UICollectionViewCell {
    
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
        label.text = "테스트"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "테스팅테스팅테스팅"
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

extension InterestViewCell: Cellable {
    
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
        descriptionLabel.text = input.title
        titleLabel.text = "#\(input.date)까지 열리는\n#\(input.category) #\(input.location)"
        
        if let path = input.image {
            service.tryDownload(filePaths: [path])
                .subscribe { [weak self] images in
                    guard let image = images.first else { return }
                    self?.imageView.image = image
                } onFailure: { [weak self] error in
                    self?.imageView.image = UIImage(named: "defaultLogo")
                    print("ImageDownLoad Fail")
                }
                .disposed(by: disposeBag)
        }
    }
    
    func getOutput() -> Output {
        return Output()
    }
}
