import UIKit

class CommentDetailViewController: UIViewController {

    var comment: Comment? //코멘트 받을 변수
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()

    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0 // 상세보기니까 무제한으로 표시
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindCommentData()
    }

    private func setupUI() {
        view.addSubview(profileImageView)
        view.addSubview(nicknameLabel)
        view.addSubview(dateLabel)
        view.addSubview(contentLabel)

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }

        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nicknameLabel)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func bindCommentData() {
        guard let comment = comment else { return }
        nicknameLabel.text = comment.nickname
        contentLabel.text = comment.content
        // dateLabel.text = comment.formattedDate()  // 필요시 추가
        if let profileUrl = URL(string: comment.profileImageUrl) {
            profileImageView.kf.setImage(with: profileUrl)
        } else {
            profileImageView.image = UIImage(named: "defaultProfileImage")
        }
    }
}
