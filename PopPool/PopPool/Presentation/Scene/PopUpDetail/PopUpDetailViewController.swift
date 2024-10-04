import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PopupDetailViewController: UIViewController {

    private var comments: [Comment] = []
    private let viewModel: PopupDetailViewModel
    private let disposeBag = DisposeBag()
    private var isDescriptionExpanded = false

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var input: PopupDetailViewModel.Input!
    private var output: PopupDetailViewModel.Output!
    private let popupData = BehaviorRelay<PopupDetail?>(value: nil)
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let imagePageControl = UIPageControl()
    private let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.register(PopupImageCell.self, forCellWithReuseIdentifier: "PopupImageCell")
        return cv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .bold, size: 16)
        label.numberOfLines = 2
        return label
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        button.tintColor = .systemGray
        return button
    }()

    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemGray
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 14)
        label.numberOfLines = 3
        return label
    }()
    
    private let showMoreButton: UIButton = {
         let button = UIButton(type: .system)
         button.setTitle("더보기", for: .normal)
         button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
         button.semanticContentAttribute = .forceRightToLeft
        button.titleLabel?.tintColor = .black
         button.titleLabel?.font = .KorFont(style: .bold, size: 12)
         return button
     }()

    private let periodLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .medium, size: 14)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .medium, size: 14)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .medium, size: 14)
        label.numberOfLines = 2
        label.isUserInteractionEnabled = true
        return label
    }()

    
    private let findRouteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("찾아가는 길 >", for: .normal)
        button.titleLabel?.font = .KorFont(style: .medium, size: 14)
        return button
    }()
    
    private lazy var commentTabControl: SegmentedControlCPNT = {
        let segmentedControl = SegmentedControlCPNT(type: .tab, segments: ["일반코멘트", "인스타코멘트"], selectedSegmentIndex: 0)
        return segmentedControl
    }()
    
    private let commentTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.reuseIdentifier)
        return tableView
    }()
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    private let showAllCommentsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전체보기", for: .normal)
        button.titleLabel?.font = .KorFont(style: .medium, size: 14)
        button.setTitleColor(.systemGray, for: .normal)
        return button

    }()
    private let similarPopupsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 보고 있는 팝업과 비슷한 팝업"
        label.font = .KorFont(style: .bold, size: 16)
        return label
    }()


    private let similarPopupsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(SimilarPopupCell.self, forCellWithReuseIdentifier: "SimilarPopupCell")
        return cv
    }()

    private let writeCommentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("코멘트 작성하기", for: .normal)
        button.titleLabel?.font = .KorFont(style: .bold, size: 16)
        button.backgroundColor = .blu500
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - Initialization
    init(viewModel: PopupDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()


    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        setupScrollView()
        setupImageCollection()
        setupInfoSection()
        setupAddressSection()
        setupCommentSection()
        setupSimilarPopups()
        setupWriteCommentButton()
        setupBackButton()
        setupShowMoreButton()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func setupBackButton() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(44)
        }
    }
    
    private func setupImageCollection() {
        contentView.addSubview(imageCollectionView)
        contentView.addSubview(imagePageControl)
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.bounds.width * 0.75)
        }
        
        imagePageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(imageCollectionView.snp.bottom).offset(-20)
        }
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    private func setupInfoSection() {
        [titleLabel, bookmarkButton, shareButton, descriptionLabel, showMoreButton,
         periodLabel, timeLabel].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(50)
            make.size.equalTo(50)
        }
        
        shareButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(44)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(bookmarkButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        showMoreButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.centerX.equalTo(descriptionLabel)
        }
        
        periodLabel.snp.makeConstraints { make in
            make.top.equalTo(showMoreButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(periodLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    private func setupAddressSection() {
        [addressLabel,  findRouteButton].forEach { contentView.addSubview($0) }
        
        addressLabel.snp.makeConstraints { make in
              make.top.equalTo(timeLabel.snp.bottom).offset(20)
              make.leading.trailing.equalToSuperview().inset(20)
          }

        findRouteButton.snp.makeConstraints { make in
               make.top.equalTo(addressLabel.snp.bottom).offset(10)
               make.trailing.equalToSuperview().inset(20)
           }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(copyAddressToClipboard))
           addressLabel.addGestureRecognizer(tapGesture)

      }
    

    private func setupCommentSection() {
        [commentTabControl, commentTableView, showAllCommentsButton, commentCountLabel].forEach { contentView.addSubview($0) }

        commentTabControl.snp.makeConstraints { make in
            make.top.equalTo(findRouteButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
        }
        
        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(commentTabControl.snp.bottom).offset(84)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(400)
        }
        
        showAllCommentsButton.snp.makeConstraints { make in
            make.top.equalTo(commentTabControl.snp.bottom).offset(24)
            make.trailing.equalToSuperview().inset(20)
        }
        commentCountLabel.snp.makeConstraints { make in
            make.top.equalTo(commentTabControl.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
        }

        commentTableView.delegate = self
        commentTableView.dataSource = self
    }
    
    private func setupSimilarPopups() {
        contentView.addSubview(similarPopupsTitleLabel)
        contentView.addSubview(similarPopupsCollectionView)
        
        similarPopupsTitleLabel.snp.makeConstraints { make in
               make.top.equalTo(commentTableView.snp.bottom).offset(60)
               make.leading.trailing.equalToSuperview().inset(20)
           }
        similarPopupsCollectionView.snp.makeConstraints { make in
               make.top.equalTo(similarPopupsTitleLabel.snp.bottom).offset(5)
               make.leading.trailing.equalToSuperview().inset(20)
               make.height.equalTo(263)
           }

        similarPopupsCollectionView.delegate = self
        similarPopupsCollectionView.dataSource = self
    }
    
    private func setupWriteCommentButton() {
        contentView.addSubview(writeCommentButton)

        writeCommentButton.snp.makeConstraints { make in
               make.top.equalTo(similarPopupsCollectionView.snp.bottom).offset(20)
               make.leading.trailing.equalToSuperview().inset(20)
               make.height.equalTo(50)
               make.bottom.equalToSuperview().offset(-20)
           }
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        input = PopupDetailViewModel.Input(
            commentType: commentTabControl.rx.selectedSegmentIndex.map {
                CommentType(rawValue: $0 == 0 ? "NORMAL" : "INSTAGRAM") ?? .normal
            }.asDriver(onErrorJustReturn: .normal),
            bookmarkButtonTapped: bookmarkButton.rx.tap.asDriver(),
            shareButtonTapped: shareButton.rx.tap.asDriver(),
            showMoreButtonTapped: showMoreButton.rx.tap.asDriver(),
            findRouteButtonTapped: findRouteButton.rx.tap.asDriver(),
            commentTabChanged: commentTabControl.rx.selectedSegmentIndex.asDriver(),
            showAllCommentsButtonTapped: showAllCommentsButton.rx.tap.asDriver(),
            writeCommentButtonTapped: writeCommentButton.rx.tap.asDriver()
        )
        
        output = viewModel.transform(input: input)
        
        output.popupData
            .drive(popupData)
            .disposed(by: disposeBag)
        
        popupData
            .subscribe(onNext: { [weak self] popup in
                if let popup = popup {
                    self?.updateUI(with: popup)
                }
            })
            .disposed(by: disposeBag)
        
        output.bookmarkToggled
            .drive(onNext: { [weak self] isBookmarked in
                self?.updateBookmarkButton(isBookmarked: isBookmarked)
            })
            .disposed(by: disposeBag)


        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        writeCommentButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presentCommentTypeVC()
            })
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
              .subscribe(onNext: { [weak self] in
                  self?.presentShareSheet()
              })
              .disposed(by: disposeBag)
//        output.addressCopied
//            .drive(onNext: { [weak self] address in
//                self?.copyAddressToClipboard(address)
//            })
//            .disposed(by: disposeBag)



    }
    
    private func updateUI(with popup: PopupDetail) {

        titleLabel.text = popup.name
        descriptionLabel.text = popup.desc
        periodLabel.text = "날짜: \(popup.formattedStartDate()) ~ \(popup.formattedEndDate())"
        timeLabel.text = "시간: 11:00 ~ 17:00"

        let attachment = NSTextAttachment()
          attachment.image = UIImage(systemName: "doc.on.doc.fill")
          let attachmentString = NSAttributedString(attachment: attachment)
          let fullString = NSMutableAttributedString(string: "주소: \(popup.address) ")
          fullString.append(attachmentString)
          addressLabel.attributedText = fullString

        imagePageControl.numberOfPages = popup.imageList.count
        updateBookmarkButton(isBookmarked: popup.bookmarkYn)
        updateShowMoreButtonState()
        self.comments = PopupDetail.dummyData.commentList
        DispatchQueue.main.async {
            self.commentTableView.reloadData()
        }
//        self.comments = popup.commentList
        commentCountLabel.text = "총\(comments.count)건"

        showAllCommentsButton.isHidden = comments.isEmpty
        imageCollectionView.reloadData()
        similarPopupsCollectionView.reloadData()
    }
    
    private func updateBookmarkButton(isBookmarked: Bool) {
        print("북마크 상태: \(isBookmarked)")
        bookmarkButton.isSelected = isBookmarked
        let bookmarkImage = isBookmarked ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        let tintColor = isBookmarked ? UIColor.systemBlue : UIColor.systemGray
        bookmarkButton.setImage(bookmarkImage, for: .normal)
        bookmarkButton.tintColor = tintColor
    }


    private func setupShowMoreButton() {
           showMoreButton.rx.tap
               .subscribe(onNext: { [weak self] in
                   self?.toggleDescriptionExpansion()
               })
               .disposed(by: disposeBag)
       }
    private func updateShowMoreButtonState() {
        descriptionLabel.numberOfLines = 0

        // 현재 레이블이 3줄을 초과하는지 계산
        let maxNumberOfLines = 3
        let labelHeight = descriptionLabel.sizeThatFits(CGSize(width: descriptionLabel.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
        let lineHeight = descriptionLabel.font.lineHeight
        let numberOfLines = Int(labelHeight / lineHeight)

        if numberOfLines > maxNumberOfLines {
            descriptionLabel.numberOfLines = maxNumberOfLines
            showMoreButton.isHidden = false
        } else {
            showMoreButton.isHidden = true
        }
    }

    private func toggleDescriptionExpansion() {
        isDescriptionExpanded.toggle() // 상태 전환

        // 설명글이 펼쳐져 있을 때
        if isDescriptionExpanded {
            descriptionLabel.numberOfLines = 0 // 무제한 줄 수로 변경
            showMoreButton.setTitle("닫기", for: .normal)
            showMoreButton.setImage(UIImage(systemName: "chevron.up"), for: .normal) // 화살표 위로
        } else {
            descriptionLabel.numberOfLines = 3 // 다시 3줄로 제한
            showMoreButton.setTitle("더보기", for: .normal)
            showMoreButton.setImage(UIImage(systemName: "chevron.down"), for: .normal) // 화살표 아래로
        }

        // 레이아웃 재설정
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    private func presentCommentTypeVC() {
        guard let popupName = popupData.value?.name else { return }

        let commentTypeVC = CommentTypeVC(popUpStore: popupName, popUpId: Int(viewModel.popupId))
        let navController = UINavigationController(rootViewController: commentTypeVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }



    private func presentShareSheet() {
        guard let popupName = popupData.value?.name else { return }

        let textToShare = "팝업스토어 이름: \(popupName)"

        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)

        // iPad에서는 Popover로 보여주기 위한 설정 (iPhone에는 필요 없음)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = shareButton.frame
        }

        present(activityViewController, animated: true, completion: nil)
    }
    @objc private func copyAddressToClipboard() {
        guard let address = popupData.value?.address else { return }
        UIPasteboard.general.string = address

        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.success)

        ToastMSGManager.createToast(message: "주소가 복사되었습니다")
    }
    


}
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension PopupDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imageCollectionView {
            return popupData.value?.imageList.count ?? 0
        } else if collectionView == similarPopupsCollectionView {
            return popupData.value?.similarPopUpStoreList.count ?? 0
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == imageCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopupImageCell", for: indexPath) as! PopupImageCell
                if let imageUrl = popupData.value?.imageList[indexPath.item].imageUrl {
                    cell.configure(with: imageUrl)
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarPopupCell", for: indexPath) as! SimilarPopupCell
                if let similarPopup = popupData.value?.similarPopUpStoreList[indexPath.item] {
                    cell.configure(with: similarPopup)
                }
                return cell
            }
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageCollectionView {
            return collectionView.bounds.size
        } else {
            let width = (collectionView.bounds.width - 16) / 2 // 2열, 중앙 여백 16
            return CGSize(width: width, height: width * 1.5) // 높이를 너비의 1.5배로 설정
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }


        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollView == imageCollectionView {
                let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
                imagePageControl.currentPage = Int(pageIndex)
            }
        }
    }

    // MARK: - UITableViewDelegate, UITableViewDataSource
    extension PopupDetailViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("총: \(comments.count)건") // 개수 확인

            return min(comments.count, 4)
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseIdentifier, for: indexPath) as! CommentCell
               let comment = comments[indexPath.row]
               print("댓글 데이터: \(comment)")
               cell.configure(with: comment)
               return cell
           }


        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }

        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }

        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
                self.updateContentSize()
            }
        }
    }

    // MARK: - Private Methods
    private extension PopupDetailViewController {
        func updateContentSize() {
            contentView.layoutIfNeeded()
            scrollView.contentSize = CGSize(width: view.bounds.width, height: contentView.bounds.height)
        }
    }
