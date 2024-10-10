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

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
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
        contentView.addSubview(containerView)
        [imageView, dateLabel, nameLabel].forEach { containerView.addSubview($0) }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(containerView.snp.width).multipliedBy(0.9)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }

        applyExternalCircularCutouts()
    }

    private func applyExternalCircularCutouts() {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 8)

        let cutoutRadius: CGFloat = 5
        let cutoutYPosition = bounds.height - cutoutRadius

        // 좌측 하단 외부 반구 모양
        let cutoutPathLeft = UIBezierPath(
            arcCenter: CGPoint(x: 0, y: cutoutYPosition),
            radius: cutoutRadius,
            startAngle: -CGFloat.pi/2,
            endAngle: CGFloat.pi/2,
            clockwise: false
        )

        // 우측 하단 외부 반구 모양
        let cutoutPathRight = UIBezierPath(
            arcCenter: CGPoint(x: bounds.width, y: cutoutYPosition),
            radius: cutoutRadius,
            startAngle: CGFloat.pi/2,
            endAngle: -CGFloat.pi/2,
            clockwise: false
        )

        path.append(cutoutPathLeft)
        path.append(cutoutPathRight)

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        containerView.layer.mask = maskLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyExternalCircularCutouts()
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
