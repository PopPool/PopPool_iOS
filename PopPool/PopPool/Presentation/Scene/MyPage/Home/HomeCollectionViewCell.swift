//
//  TestingHomeCollectionViewCell.swift
//  PopPool
//
//  Created by Porori on 8/17/24.
//

import UIKit
import SnapKit
import RxSwift

final class HomeCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lasso")
        return imageView
    }()
    
    // pageControl을 생성하는 형식
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    var changedPage: Int = 0 {
        didSet {
            pageControl.currentPage = changedPage
        }
    }
    let pageIndex: PublishSubject<Int> = .init()
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpConstraint()
    }
    
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
    
    public func setUpPageControl(totalPage: Int) {
        pageControl.numberOfPages = totalPage
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
