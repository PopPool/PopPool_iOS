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

final class SocialCommentVC: BaseViewController {
    
    enum Section {
        case firstGuide
        case secondGuide
        case thirdGuide
        case fourthGuide
        
        var attributeText: String {
            switch self {
            case .firstGuide: return "아래 인스타그램 열기"
            case .secondGuide: return "공유하기 > 링크복사"
            case .thirdGuide: return "팝풀 앱"
            case .fourthGuide: return "글을 입력 후 등록"
            }
        }
    }
    
    let header = HeaderViewCPNT(
        title: "코멘트 작성하기",
        style: .icon(nil))
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    let topSectionView = SocialNoticeView()
    var secondSectionView: SocialCommentView!
    let pageSpaceView = UIView()
    
    let guideImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
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
    let viewModel: SocialCommentVM
    
    init(viewModel: SocialCommentVM) {
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
        let input = SocialCommentVM.Input()
        let output = viewModel.transform(input: input)
        
        output.content
            .withUnretained(self)
            .subscribe(onNext: { (owner, content) in
                let currentPage = owner.pageControl.currentPage
                let attributeText = owner.createStyledText(from: content.title)
                owner.guideImage.image = UIImage(named: content.image)
                owner.topSectionView.updateView(
                    number: currentPage,
                    title: attributeText
                )
            })
            .disposed(by: disposeBag)
        
        swipeLeft.rx.event
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                let currentPage = owner.pageControl.currentPage
                if currentPage < owner.viewModel.currentContentCount - 1 {
                    owner.pageControl.currentPage += 1
                    owner.viewModel.updateView(for: currentPage+1)
                }
            })
            .disposed(by: disposeBag)
        
        swipeRight.rx.event
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                let currentPage = owner.pageControl.currentPage
                if currentPage >= 0 {
                    owner.pageControl.currentPage -= 1
                    owner.viewModel.updateView(for: currentPage-1)
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
    
    private func createStyledText(from text: String) -> NSMutableAttributedString {
        let fullText = text as NSString
        let attributedString = NSMutableAttributedString(string: text)
        
        if text.contains(Section.firstGuide.attributeText) {
            let range = fullText.range(of: Section.firstGuide.attributeText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blu500, range: range)
        }
        
        if text.contains(Section.secondGuide.attributeText) {
            let range = fullText.range(of: Section.secondGuide.attributeText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blu500, range: range)
        }
        
        if text.contains(Section.thirdGuide.attributeText) {
            let range = fullText.range(of: Section.thirdGuide.attributeText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blu500, range: range)
        }
        
        if text.contains(Section.fourthGuide.attributeText) {
            let range = fullText.range(of: Section.fourthGuide.attributeText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blu500, range: range)
        }
        
        return attributedString
    }
    
    private func openUniversalLink() {
        let url = NSURL(string: "https://www.instagram.com")
        
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL)
        }
        
        removeFromView()
        reSetUpConstraint()
        pasteTest()
    }
    
    private func removeFromView() {
        for subView in stack.arrangedSubviews {
            stack.removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
        stack.removeFromSuperview()
    }
    
    private func reSetUpConstraint() {
        secondSectionView = SocialCommentView()
        view.addSubview(secondSectionView)
        
        secondSectionView.snp.remakeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(actionButton.snp.top)
        }
        
        view.layoutIfNeeded()
    }
    
    private func pasteTest() {
        viewModel.fetchImage()
            .withUnretained(self)
            .subscribe(onNext: { (owner, image) in
                DispatchQueue.main.async {
                    if image.isEmpty {
                        owner.guideImage.image = UIImage(systemName: "lasso")
                        owner.guideImage.layer.borderColor = UIColor.red.cgColor
                        owner.guideImage.layer.borderWidth = 2
                    } else {
                        owner.guideImage.image = UIImage(data: image)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setUp() {
        swipeLeft.direction = .left
        swipeRight.direction = .right
        guideImage.addGestureRecognizer(swipeLeft)
        guideImage.addGestureRecognizer(swipeRight)
        
        pageControl.numberOfPages = viewModel.currentContentCount
        
        containerView.backgroundColor = .yellow
        scrollView.backgroundColor = .orange
    }
    
    private func setUpConstraint() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(stack)
        containerView.addSubview(actionButton)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(view.safeAreaLayoutGuide)
        }
        
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
