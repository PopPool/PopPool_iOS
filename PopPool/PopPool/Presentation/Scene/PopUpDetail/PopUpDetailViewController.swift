import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PopupDetailViewController: UIViewController {
    private let viewModel: PopupDetailViewModel
    private let disposeBag = DisposeBag()

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    

    private var input: PopupDetailViewModel.Input!
      private var output: PopupDetailViewModel.Output!
      private let popupData = BehaviorRelay<PopupDetail?>(value: nil)

//    commentTableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
//    imageCollectionView.register(PopupImageCell.self, forCellWithReuseIdentifier: PopupImageCell.identifier)


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
    private let commentTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        return tableView
    }()

    private let titleLabel = UILabel()
    private let likeButton = UIButton()
    private let shareButton = UIButton()
    private let descriptionLabel = UILabel()
    private let showMoreButton = UIButton()
    private let periodLabel = UILabel()
    private let timeLabel = UILabel()
    private let addressLabel = UILabel()
    private let copyAddressButton = UIButton()
    private let findRouteButton = UIButton()

    private let commentTabControl = UISegmentedControl(items: ["일반", "인스타"])
    private let showAllCommentsButton = UIButton()

    private let writeCommentButton = UIButton()

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

        commentTableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.reuseIdentifier)
        imageCollectionView.register(PopupImageCell.self, forCellWithReuseIdentifier: PopupImageCell.reuseIdentifier)
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        setupScrollView()
        setupImageCollection()
        setupInfoSection()
        setupCommentSection()
        setupWriteCommentButton()
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

    private func setupImageCollection() {
        contentView.addSubview(imageCollectionView)
        contentView.addSubview(imagePageControl)

        imageCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }

        imagePageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(imageCollectionView.snp.bottom).offset(-20)
        }
    }

    private func setupInfoSection() {
        [titleLabel, likeButton, shareButton, descriptionLabel, showMoreButton,
         periodLabel, timeLabel, addressLabel, copyAddressButton, findRouteButton].forEach { contentView.addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        likeButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(44)
        }

        shareButton.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.leading.equalTo(likeButton.snp.trailing).offset(10)
            make.size.equalTo(44)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        showMoreButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }

        periodLabel.snp.makeConstraints { make in
            make.top.equalTo(showMoreButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(periodLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }

        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        copyAddressButton.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }

        findRouteButton.snp.makeConstraints { make in
            make.centerY.equalTo(copyAddressButton)
            make.leading.equalTo(copyAddressButton.snp.trailing).offset(10)
        }
    }

    private func setupCommentSection() {
        [commentTabControl, commentTableView, showAllCommentsButton].forEach { contentView.addSubview($0) }

        commentTabControl.snp.makeConstraints { make in
            make.top.equalTo(findRouteButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(commentTabControl.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }

        showAllCommentsButton.snp.makeConstraints { make in
            make.top.equalTo(commentTableView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    private func setupWriteCommentButton() {
        view.addSubview(writeCommentButton)

        writeCommentButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }

    // MARK: - Binding
    private func bindViewModel() {
        input = PopupDetailViewModel.Input(
            commentType: commentTabControl.rx.selectedSegmentIndex.map {
                CommentType(rawValue: $0 == 0 ? "NORMAL" : "INSTAGRAM") ?? .normal
            }.asDriver(onErrorJustReturn: .normal),
            likeButtonTapped: likeButton.rx.tap.asDriver(),
            shareButtonTapped: shareButton.rx.tap.asDriver(),
            showMoreButtonTapped: showMoreButton.rx.tap.asDriver(),
            copyAddressButtonTapped: copyAddressButton.rx.tap.asDriver(),
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
                    self?.imageCollectionView.reloadData()
                    self?.commentTableView.reloadData()
                }
            })
            .disposed(by: disposeBag)


        output.bookmarkToggled
            .drive(onNext: { [weak self] isBookmarked in
                self?.updateLikeButton(isLiked: isBookmarked)
            })
            .disposed(by: disposeBag)
    }



    private func updateUI(with popup: PopupDetail) {
        titleLabel.text = popup.name
        descriptionLabel.text = popup.desc
        periodLabel.text = "\(popup.startDate) ~ \(popup.endDate)"
        timeLabel.text = "운영 시간 정보 추가 필요"
        addressLabel.text = popup.address
        imagePageControl.numberOfPages = popup.imageList.count
        imageCollectionView.reloadData()
        commentTableView.reloadData()
    }

    private func updateLikeButton(isLiked: Bool) {
        likeButton.isSelected = isLiked
    }
}

extension PopupDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popupData.value?.imageList.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopupImageCell.reuseIdentifier, for: indexPath) as! PopupImageCell
        if let imageUrl = popupData.value?.imageList[indexPath.item].imageUrl {
            cell.configure(with: imageUrl)
        }
        return cell
    }
}

extension PopupDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popupData.value?.commentList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseIdentifier, for: indexPath) as! CommentCell
        if let comment = popupData.value?.commentList[indexPath.row] {
            cell.configure(with: comment)
        }
        return cell
    }
}
