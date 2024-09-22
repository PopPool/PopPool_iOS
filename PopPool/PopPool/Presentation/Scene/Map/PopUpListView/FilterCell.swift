import UIKit
import SnapKit

class FilterCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let removeButton = UIButton(type: .system)
    var onRemove: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // 설정
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .systemBlue

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemBlue.cgColor

        contentView.addSubview(titleLabel)
        contentView.addSubview(removeButton)

        // 오토레이아웃 설정
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }

        removeButton.snp.makeConstraints { make in
//            make.leading.equalTo(titleLabel.snp.trailing).offset(1)
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(12)
        }

        // 버튼 설정
        removeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        removeButton.tintColor = .systemBlue
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }

    // 셀 콘텐츠 설정
    func configure(with title: String) {
        titleLabel.text = title

        let cellWidth = titleLabel.intrinsicContentSize.width + removeButton.intrinsicContentSize.width + 16 // 여백 포함
        contentView.snp.updateConstraints { make in
            make.width.equalTo(cellWidth)
            make.height.equalTo(32)
        }

        setNeedsLayout()
        layoutIfNeeded()
    }

    // 제거 버튼 클릭 시 호출되는 메서드
    @objc private func removeButtonTapped() {
        onRemove?()
    }

    // 콘텐츠 크기에 맞춰 셀의 크기를 자동으로 조정
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        // 목표 크기 설정
        let targetSize = CGSize(width: attributes.frame.width, height: 32)
        let size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .fittingSizeLevel)
        attributes.frame.size = size
        return attributes
    }
}
