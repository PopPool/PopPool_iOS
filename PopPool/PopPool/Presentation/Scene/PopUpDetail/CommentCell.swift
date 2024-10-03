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
        label.numberOfLines = 0
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [profileImageView, nicknameLabel, commentLabel, dateLabel].forEach { contentView.addSubview($0) }

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
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nicknameLabel)
            make.trailing.equalToSuperview().offset(-10)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(5)
            make.leading.equalTo(nicknameLabel)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

    func configure(with comment: Comment) {
        nicknameLabel.text = comment.nickname
        commentLabel.text = comment.content
//        dateLabel.text = formatDate(comment.createDateTime)

        if comment.profileImageUrl == "defaultProfileImage" {
            profileImageView.image = UIImage(named: "defaultProfileImage")
        } else if let url = URL(string: comment.profileImageUrl) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultProfileImage"))
        }

        // Instagram ID가 있는 경우 표시
        if let instagramId = comment.instagramId {
            nicknameLabel.text = "\(comment.nickname) (@\(instagramId))"
        }

        // 좋아요 수 표시 (옵션)
        // likeCountLabel.text = "\(comment.likeCount) 좋아요"

        // 댓글 이미지 표시 (첫 번째 이미지만 표시하는 경우)
        if let firstImage = comment.commentImageList.first {
            // 이미지 뷰를 추가하고 이미지 로드
            // commentImageView.kf.setImage(with: URL(string: firstImage.imageUrl))
        }
    }
}
