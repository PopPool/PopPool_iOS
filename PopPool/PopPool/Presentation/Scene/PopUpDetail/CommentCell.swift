import UIKit
import SnapKit
import Kingfisher

class CommentCell: UITableViewCell {
    static let reuseIdentifier = "CommentCell"
    private var comment: Comment?
    var userId: String?


    private let commentImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CommentGalleryCell.self, forCellWithReuseIdentifier: "CommentGalleryCell")
        return collectionView
    }()

    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()

    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()

    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("도움돼요 0", for: .normal)
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        button.tintColor = .gray
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }()

    private let showMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("코멘트 전체보기 >", for: .normal)
        button.titleLabel?.font = .KorFont(style: .bold, size: 12)
        button.setTitleColor(.black, for: .normal)
        button.isHidden = true
        return button
    }()
    private let moreButton: UIButton = {
            let button = UIButton(type: .system)
            let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
            let image = UIImage(systemName: "ellipsis", withConfiguration: config)
            button.setImage(image, for: .normal)
            button.tintColor = .gray
            return button
        }()

    private var isExpanded = false
    private var isLiked = false
    private var likeCount = 0

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        [profileImageView, nicknameLabel, commentImageCollectionView, commentLabel, dateLabel, likeButton, showMoreButton, moreButton].forEach {
            contentView.addSubview($0)
        }

        profileImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
            make.width.height.equalTo(40)
        }

        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }

        commentImageCollectionView.snp.makeConstraints { make in
              make.top.equalTo(profileImageView.snp.bottom).offset(10)
              make.leading.trailing.equalToSuperview().inset(10)
              if let commentImages = comment?.commentImageList, !commentImages.isEmpty {
                  make.height.equalTo(100)
              } else {
                  make.height.equalTo(0)
              }
          }

          commentLabel.snp.makeConstraints { make in
              if let commentImages = comment?.commentImageList, commentImages.isEmpty {
                  make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
              } else {
                  make.top.equalTo(commentImageCollectionView.snp.bottom).offset(10)
              }
              make.leading.equalToSuperview().offset(10)
              make.trailing.equalToSuperview().offset(-10)
          }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(5)
            make.leading.equalTo(nicknameLabel)
        }

        likeButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.leading.equalTo(nicknameLabel).offset(200)
            make.bottom.equalToSuperview().offset(-10)
        }

        showMoreButton.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(5)
            make.centerX.equalTo(contentView)
            make.bottom.equalToSuperview().offset(-10)
        }
        moreButton.snp.makeConstraints { make in
            make.top.centerY.equalTo(nicknameLabel)
            make.trailing.equalToSuperview().inset(30)
        }

        commentImageCollectionView.delegate = self
        commentImageCollectionView.dataSource = self
    }

    // MARK: - Actions Setup
    private func setupActions() {
        likeButton.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
        showMoreButton.addTarget(self, action: #selector(didTapShowMore), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(presentUserMoreInfo), for: .touchUpInside)

    }

    // MARK: - Button Actions
    @objc private func handleLikeButtonTapped() {
        isLiked.toggle()
        likeCount += isLiked ? 1 : -1
        updateLikeButton()
    }

    @objc private func didTapShowMore() {
        guard let comment = comment else { return }

        if let parentVC = self.parentViewController() {
            let commentDetailVC = CommentDetailViewController()
            commentDetailVC.comment = comment
            commentDetailVC.modalPresentationStyle = .pageSheet

            if let sheet = commentDetailVC.sheetPresentationController {
                sheet.detents = [.medium()]
//                sheet.prefersGrabberVisible = true
            }

            parentVC.present(commentDetailVC, animated: true, completion: nil)
        }
    }
    @objc private func presentUserMoreInfo() {
        guard let nickname = comment?.nickname, let userId = self.userId else { return }
        if let parentVC = self.parentViewController() as? PopupDetailViewController {
            parentVC.presentUserMoreInfo(nickname: nickname, userId: userId)
        }
    }



    // MARK: - Configuration
    func configure(with comment: Comment, userId: String) {
        self.comment = comment
        self.userId = userId
        nicknameLabel.text = comment.nickname
        commentLabel.text = comment.content
        likeCount = comment.likeCount
        updateLikeButton()

        // 프로필 이미지 설정
        if comment.profileImageUrl == "defaultImage" {
            profileImageView.image = UIImage(named: "defaultImage")
        } else if let url = URL(string: comment.profileImageUrl ?? "") {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"))
        }

        // 이미지 리스트 처리
        if let commentImages = comment.commentImageList, !commentImages.isEmpty {
            commentImageCollectionView.isHidden = false
            commentImageCollectionView.snp.updateConstraints { make in
                make.height.equalTo(100) // 이미지가 있을 때 높이 설정
            }
            commentImageCollectionView.reloadData()
        } else {
            commentImageCollectionView.isHidden = true
            commentImageCollectionView.snp.updateConstraints { make in
                make.height.equalTo(0) // 이미지가 없을 때 높이를 0으로 설정
            }
        }

        // 초기 상태 설정
        commentLabel.numberOfLines = 3
        showMoreButton.isHidden = true
        isExpanded = false

        DispatchQueue.main.async { [weak self] in
            self?.updateShowMoreButtonVisibility()
        }
    }


    // MARK: - Helper Methods
    private func updateLikeButton() {
        likeButton.setTitle("도움돼요 \(likeCount)", for: .normal)
        likeButton.tintColor = isLiked ? .blue : .gray
    }

    private func updateShowMoreButtonVisibility() {
        let maxLines = 3
        commentLabel.numberOfLines = 0

        let fullTextHeight = commentLabel.sizeThatFits(CGSize(width: commentLabel.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height

        let lineHeight = commentLabel.font.lineHeight
        let actualNumberOfLines = Int(fullTextHeight / lineHeight)

        if actualNumberOfLines > maxLines {
            showMoreButton.isHidden = false
            commentLabel.numberOfLines = maxLines // 3줄 제한
        } else {
            showMoreButton.isHidden = true
            commentLabel.numberOfLines = 0
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CommentCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comment?.commentImageList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentGalleryCell", for: indexPath) as! CommentGalleryCell
        if let imageUrl = comment?.commentImageList?[indexPath.item].imageUrl {
            cell.configure(with: imageUrl)
        }
        return cell
    }
}

// MARK: - UICollectionViewFlowLayout
extension CommentCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
extension UIResponder {
    func parentViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let r = responder {
            responder = r.next
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
