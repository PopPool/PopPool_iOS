import UIKit
import SnapKit
import Kingfisher

class CommentCell: UITableViewCell {
    static let reuseIdentifier = "CommentCell"

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
        [profileImageView, nicknameLabel, commentLabel, dateLabel, likeButton, showMoreButton].forEach {
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

        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(34)
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
    }

    // MARK: - Actions Setup
    private func setupActions() {
        likeButton.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
        showMoreButton.addTarget(self, action: #selector(didTapShowMore), for: .touchUpInside)
    }

    // MARK: - Button Actions
    @objc private func handleLikeButtonTapped() {
        isLiked.toggle()
        likeCount += isLiked ? 1 : -1
        updateLikeButton()
    }

    @objc private func didTapShowMore() {
        isExpanded.toggle()
        commentLabel.numberOfLines = isExpanded ? 0 : 3
        updateShowMoreButtonVisibility() // '코멘트 전체보기' 버튼 가시성 업데이트
    }
    private func presentAllCommentsModal() {
        let allCommentsVC = AllCommentsViewController()
        allCommentsVC.comments = (parentViewController as? PopupDetailViewController)?.comments ?? []
        allCommentsVC.modalPresentationStyle = .overFullScreen
        allCommentsVC.modalTransitionStyle = .crossDissolve

        if let parentVC = self.parentViewController {
            parentVC.present(allCommentsVC, animated: true, completion: nil)
        }
    }

    // MARK: - Helper Methods
    private func updateLikeButton() {
        likeButton.setTitle("도움돼요 \(likeCount)", for: .normal)
        likeButton.tintColor = isLiked ? .blue : .gray
    }

    private func updateShowMoreButtonVisibility() {
        let maxLines = 3
        commentLabel.numberOfLines = 0 // 먼저 제한을 품

        // 텍스트의 전체 높이를 계산합니다.
        let fullTextHeight = commentLabel.sizeThatFits(CGSize(width: commentLabel.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height

        let lineHeight = commentLabel.font.lineHeight

        let actualNumberOfLines = Int(fullTextHeight / lineHeight)

        // 3줄을 초과하는 경우에만 showMoreButton을 표시
        if actualNumberOfLines > maxLines {
            showMoreButton.isHidden = false
            commentLabel.numberOfLines = maxLines // 3줄 제한
        } else {
            showMoreButton.isHidden = true
            commentLabel.numberOfLines = 0 // 제한 X
        }
    }

    // MARK: - Configuration
    func configure(with comment: Comment) {
        nicknameLabel.text = comment.nickname
        commentLabel.text = comment.content
//        dateLabel.text = comment.formattedDate()
        likeCount = comment.likeCount
        updateLikeButton()

        if comment.profileImageUrl == "defaultImage" {
            profileImageView.image = UIImage(named: "defaultImage")
        } else if let url = URL(string: comment.profileImageUrl) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"))
        }

        // 초기 상태 설정
        commentLabel.numberOfLines = 3
        showMoreButton.isHidden = true
        isExpanded = false

        // 레이아웃 업데이트 후 '코멘트 전체보기' 버튼 표시 여부 결정
        DispatchQueue.main.async { [weak self] in
            self?.updateShowMoreButtonVisibility()
        }
    }
}
extension UITableViewCell {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

