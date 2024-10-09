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
    
    var onCommentAdded: (() -> Void)?

    let header = HeaderViewCPNT(
        title: "코멘트 작성하기",
        style: .icon(nil))
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    let topSectionView = SocialNoticeView()
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
    var dynamicTextfield: DynamicTextViewCPNT!
    var isScrollEnabled: Bool = false
    var isIGContentCopied: Bool = false
    let imageData: BehaviorRelay<UIImage?> = .init(value: nil)
    
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
        
        output.isLoaded
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.actionButton.showToolTip(color: .w100, direction: .pointDown, text: "잠깐, 비공개 계정은 게시물을 올릴 수 없어요 :(")
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
                if owner.isIGContentCopied {
                    owner.postCopiedSocialContent()
                    owner.navigationController?.popToRootViewController(animated: true)
                } else {
                    owner.openUniversalLink()
                }
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
        
        let copiedToClipboard = viewModel.isCopiedToClipboard
        isIGContentCopied = false
        print("복사 여부", copiedToClipboard)
        if copiedToClipboard {
            removeFromStack()
            reSetUpConstraint()
            pasteTest()
            updateScrollViewIfNeeded()
            isIGContentCopied = true
        }
    }
    
    private func postCopiedSocialContent() {
        guard let image = imageData.value else { return }
        
        let imageService = PreSignedService()
        var pathList: [String] = []
        var imageUploadDatas: [PreSignedService.PresignedURLRequest] = []
        let commentRequest = CreateCommentRequestDTO(
            userId: Constants.userId,
            popUpStoreId: viewModel.popUpId,
            content: dynamicTextfield.textView.text,
            commentType: .instagram,
            imageUrlList: []
        )

        let path = "comments/social/\(image)"
        pathList.append(path)
        imageUploadDatas.append(.init(
            filePath: path,
            image: image
        ))
        
        imageService.tryUpload(datas: imageUploadDatas)
            .subscribe(onSuccess: { _ in
                
                // 이미지 업로드하며 코멘트 업로드 진행
                let repository = CommentRepositoryImpl()
                let popUpStore = CreateCommentRequestDTO(
                    userId: commentRequest.userId,
                    popUpStoreId: commentRequest.popUpStoreId,
                    content: commentRequest.content,
                    commentType: commentRequest.commentType,
                    imageUrlList: pathList)
                
                repository.postComment(request: popUpStore)
                    .subscribe { _ in
                        ToastMSGManager.createToast(message: "코멘트 작성을 완료했어요")
//                        owner.onCommentAdded?()
                    }
                    .disposed(by: self.disposeBag)
                
            }, onFailure: { error in
                print("코멘트 업로드 중 오류")
                ToastMSGManager.createToast(message: "코멘트 업로드 도중 문제가 발생했어요")
            })
            .disposed(by: disposeBag)
    }
    
    private func removeFromStack() {
        for subView in stack.arrangedSubviews {
            stack.removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
    }
    
    private func reSetUpConstraint() {
        dynamicTextfield = DynamicTextViewCPNT(placeholder: "테스트", textLimit: 10)
        containerView.addSubview(header)
        containerView.addSubview(guideImage)
        containerView.addSubview(dynamicTextfield)
        
        guideImage.image = UIImage(systemName: "lasso")
        guideImage.contentMode = .scaleAspectFit
        
        header.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        guideImage.snp.remakeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(Constants.spaceGuide.small300)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(376)
        }
        
        dynamicTextfield.snp.remakeConstraints { make in
            make.top.equalTo(guideImage.snp.bottom).offset(Constants.spaceGuide.medium100)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview().inset(Constants.spaceGuide.medium100)
        }
        
        dynamicTextfield.rx.observe(CGRect.self, "bounds")
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.updateScrollViewIfNeeded()
            })
            .disposed(by: disposeBag)
        
        actionButton.iconImageView.image = nil
        actionButton.setTitle("저장", for: .normal)
        
        view.layoutIfNeeded()
        scrollView.layoutIfNeeded()
    }
    
    private func updateScrollViewIfNeeded() {
        let contentHeight = containerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: contentHeight)
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
                        let fetchedImage = UIImage(data: image)
                        owner.guideImage.image = UIImage(data: image)
                        owner.imageData.accept(fetchedImage)
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
        scrollView.isScrollEnabled = true
        
        pageControl.numberOfPages = viewModel.currentContentCount
    }
    
    private func setUpConstraint() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(stack)
        view.addSubview(actionButton)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.snp.width)
        }
        
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
