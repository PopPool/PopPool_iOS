import UIKit
import SnapKit
import Kingfisher

class SimilarPopupCell: UICollectionViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return iv
    }()

    private let punchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
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
        contentView.addSubview(containerView)
        [imageView, punchView, dateLabel, nameLabel].forEach { containerView.addSubview($0) }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(containerView.snp.width).multipliedBy(0.75)
        }

        punchView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(-10)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(punchView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        punchView.layer.cornerRadius = punchView.bounds.height / 2
    }

    func configure(with similarPopup: SimilarPopUp) {
        dateLabel.text = "~ \(similarPopup.formattedEndDate())"
        nameLabel.text = similarPopup.name

        if let url = URL(string: similarPopup.mainImageUrl) {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"))
        } else {
            imageView.image = UIImage(named: "defaultImage")
        }
    }
}
