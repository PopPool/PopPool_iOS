import UIKit
import SnapKit
import Kingfisher

class PopupImageCell: UICollectionViewCell {

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .gray // 기본 배경 컬러
        return iv
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
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(with imageUrl: String?) {
        let defaultImage = UIImage(named: "defaultImage")

        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            imageView.kf.setImage(
                with: url,
                placeholder: defaultImage, // 기본 이미지 설정
                options: nil,
                completionHandler: { result in
                    switch result {
                    case .success(let value):
                        print("이미지 로드 성공: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("이미지 로드 실패: \(error.localizedDescription)")
                        self.imageView.image = defaultImage
                    }
                }
            )
        } else {
            imageView.image = defaultImage
            print("유효하지 않은 URL이므로 기본 이미지를 사용합니다.")
        }
    }
}
