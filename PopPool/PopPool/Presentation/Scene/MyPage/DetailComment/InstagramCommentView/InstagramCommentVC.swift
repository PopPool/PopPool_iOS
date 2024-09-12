//
//  InstagramCommentVC.swift
//  PopPool
//
//  Created by Porori on 9/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class InstagramCommentVC: BaseViewController {
    
    let imageSet = ["photo", "lasso", "person", "circle", "folder.fill"]
    
    let header = HeaderViewCPNT(
        title: "코멘트 작성하기",
        style: .icon(nil))
    
    let topSectionView = InstagramView()
    let pageSpaceView = UIView()
    
    let guideImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .g900
        pageControl.pageIndicatorTintColor = .pb30
        return pageControl
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.addArrangedSubview(header)
        stack.addArrangedSubview(topSectionView)
        stack.addArrangedSubview(guideImage)
        stack.addArrangedSubview(pageSpaceView)
        stack.addArrangedSubview(pageControl)
        return stack
    }()
    
    let actionButton = ButtonCPNT(
        type: .instagram,
        title: "Instagram 열기")

    let swipeLeft = UISwipeGestureRecognizer()
    let swipeRight = UISwipeGestureRecognizer()
    let disposeBag = DisposeBag()
    let viewModel: InstagramVM
    
    init(viewModel: InstagramVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraint()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func bind() {
        
        swipeLeft.rx.event
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                var currentPage = owner.pageControl.currentPage
                if currentPage < owner.imageSet.count - 1 {
                    UIView.transition(
                        with: owner.guideImage,
                        duration: 1,
                        options: .curveEaseInOut,
                        animations: {
                            let test = "원하는 피드의 이미지로 이동 후 공유하기 > 링크복사 터치하기"
                            self.topSectionView.updateView(number: currentPage + 1, title: test)
                            owner.pageControl.currentPage += 1
                            currentPage = owner.pageControl.currentPage
                            owner.guideImage.image = UIImage(systemName: owner.imageSet[currentPage])
                    })
                }
            })
            .disposed(by: disposeBag)
        
        swipeRight.rx.event
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                var currentPage = owner.pageControl.currentPage
                if currentPage > 0 {
                    let test = "아래 인스타그램 열기\n버튼을 터치해 앱 열기"
                    self.topSectionView.updateView(number: currentPage - 1, title: test)
                    owner.pageControl.currentPage -= 1
                    currentPage = owner.pageControl.currentPage
                    owner.guideImage.image = UIImage(systemName: owner.imageSet[currentPage])
                }
            })
            .disposed(by: disposeBag)
        
        actionButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.openUniversalLink()
            })
            .disposed(by: disposeBag)
    }
    
    private func openUniversalLink() {
        let url = NSURL(string: "https://www.instagram.com")
        
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL)
        }
    }
    
    private func setUp() {
        swipeLeft.direction = .left
        swipeRight.direction = .right
        guideImage.addGestureRecognizer(swipeLeft)
        guideImage.addGestureRecognizer(swipeRight)
        
        pageControl.numberOfPages = imageSet.count
        guideImage.image = UIImage(systemName: imageSet[0])
    }
    
    private func setUpConstraint() {
        view.addSubview(stack)
        view.addSubview(actionButton)
        
        stack.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        guideImage.snp.makeConstraints { make in
            make.height.equalTo(guideImage.snp.width)
        }
        
        pageSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small100)
        }
        
        pageControl.snp.makeConstraints { make in
            make.height.equalTo(10)
        }
        
        actionButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Constants.spaceGuide.medium400)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
    }
}
