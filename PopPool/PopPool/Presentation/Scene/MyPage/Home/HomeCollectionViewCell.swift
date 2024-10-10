//
//  TestingHomeCollectionViewCell.swift
//  PopPool
//
//  Created by Porori on 8/17/24.
//

import UIKit
import SnapKit
import RxSwift
import Kingfisher

final class HomeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Component
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lasso")
        return imageView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    // MARK: - Properties
    
    var changedPage: Int = 0 {
        didSet {
            pageControl.currentPage = changedPage
        }
    }
    let pageIndex: PublishSubject<Int> = .init()
    var disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpConstraint()
    }
    
    // MARK: - Methods
    
    private func bind() {
        pageIndex
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] index in
                self?.changedPage = index
            })
            .disposed(by: disposeBag)
    }
    
    public func setImage(image: UIImage?) {
        self.imageView.image = image
    }
    
    private func setUpConstraint() {
        if !self.contentView.subviews.contains(imageView) {
            self.contentView.addSubview(imageView)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        window?.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom).inset(24)
        }
    }
}

extension HomeCollectionViewCell: Cellable {
    
    struct Input {
        var image: String?
        var totalCount: Int
    }
    
    struct Output {
        
    }
    
    /// 배너 역할을 하는 cell에 데이터를 주입하는 메서드
    /// - Parameter input: Input 값을 받습니다
    func injectionWith(input: Input) {
        if let bannerImageUrl = input.image {
            let service = PreSignedService()
            imageView.setPresignedImage(from: [bannerImageUrl], service: service, bag: disposeBag)
                .subscribe(onCompleted: { [weak self] in
                    self?.pageControl.numberOfPages = input.totalCount
                })
                .disposed(by: disposeBag)
        } else {
            imageView.image = UIImage(named: "defaultLogo") // 배너 기본 이미지 설정
        }
    }
    
    func getOutput() -> Output {
        return Output()
    }
}
