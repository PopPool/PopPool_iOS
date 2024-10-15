import UIKit

class UserCommentCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()

    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.backgroundColor = .black.withAlphaComponent(0.5)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        imageView.addSubview(commentCountLabel)

        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }

        commentCountLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
    }
    func configure(with comment: MyCommentInfo) {
           titleLabel.text = comment.popUpStoreInfo.popUpStoreName
           dateLabel.text = formatDate(comment.createDateTime)
           commentCountLabel.text = "👁 \(comment.likeCount)"

           if let mainImageUrl = comment.popUpStoreInfo.mainImageUrl,
              let url = URL(string: mainImageUrl) {
               imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
           } else {
               imageView.image = UIImage(named: "placeholder")
           }
       }
       private func formatDate(_ date: Date) -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy.MM.dd"
           return formatter.string(from: date)
       }
   }
