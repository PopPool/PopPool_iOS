import UIKit
import SnapKit
import Kingfisher

class PopupListCell: UICollectionViewCell {
    static let reuseIdentifier = "PopupListCell"

    var store: PopUpStore?

    private let popupImageView = UIImageView()
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let addressLabel = UILabel()
    private let dateLabel = UILabel()
    private let bookmarkButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
           contentView.addSubview(popupImageView)
           contentView.addSubview(nameLabel)
           contentView.addSubview(categoryLabel)
           contentView.addSubview(addressLabel)
           contentView.addSubview(dateLabel)
           contentView.addSubview(bookmarkButton)

//           contentView.layer.cornerRadius = 8
//           contentView.clipsToBounds = true

           popupImageView.snp.makeConstraints {
               $0.top.leading.trailing.equalToSuperview()
               $0.height.equalTo(170) // 고정된 높이
           }

           popupImageView.contentMode = .scaleAspectFill
           popupImageView.clipsToBounds = true
        popupImageView.layer.cornerRadius = 8

           popupImageView.backgroundColor = .lightGray

           // bookmarkButton 제약 설정
           bookmarkButton.snp.makeConstraints {
               $0.top.trailing.equalToSuperview().inset(8)
               $0.size.equalTo(CGSize(width: 24, height: 24))
           }
           bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)

           // categoryLabel 제약 설정 (이전의 nameLabel 위치)
           categoryLabel.snp.makeConstraints {
               $0.top.equalTo(popupImageView.snp.bottom).offset(8)
               $0.leading.trailing.equalToSuperview().inset(8)
           }
           categoryLabel.font = .systemFont(ofSize: 12)
           categoryLabel.textColor = .systemBlue
           categoryLabel.layer.cornerRadius = 4
           categoryLabel.clipsToBounds = true

           // nameLabel 제약 설정 (이전의 categoryLabel 위치)
           nameLabel.snp.makeConstraints {
               $0.top.equalTo(categoryLabel.snp.bottom).offset(4)
               $0.leading.trailing.equalToSuperview().inset(8)
           }
           nameLabel.font = .systemFont(ofSize: 14, weight: .bold)
           nameLabel.numberOfLines = 2

           // addressLabel 제약 설정
           addressLabel.snp.makeConstraints {
               $0.top.equalTo(nameLabel.snp.bottom).offset(4)
               $0.leading.trailing.equalToSuperview().inset(8)
           }
           addressLabel.font = .systemFont(ofSize: 12)
           addressLabel.textColor = .gray

           // dateLabel 제약 설정
           dateLabel.snp.makeConstraints {
               $0.top.equalTo(addressLabel.snp.bottom).offset(4)
               $0.leading.trailing.equalToSuperview().inset(8)
               $0.bottom.lessThanOrEqualToSuperview().inset(8)
           }
           dateLabel.font = .systemFont(ofSize: 12)
           dateLabel.textColor = .gray
       }


    func configure(with store: PopUpStore) {
        self.store = store
        print("리스트뷰 데이터 =\(store)")

        nameLabel.text = store.name
        print("셀에 설정할 스토어 이름: \(store.name)")

        categoryLabel.text = "# \(store.category)"
        print("카테고리 라벨: \(store.category)")
        addressLabel.text = store.address
        print("주소 라벨: \(store.address)")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy.MM.dd"

        if let startDate = dateFormatter.date(from: store.startDate),
           let endDate = dateFormatter.date(from: store.endDate) {
            let startDateString = outputFormatter.string(from: startDate)
            let endDateString = outputFormatter.string(from: endDate)
            dateLabel.text = "\(startDateString) - \(endDateString)"
        } else {
            dateLabel.text = "날짜 정보 없음"
        }
    }

    func configureImage(with image: PopUpStoreImage?) {
        if let image = image, let mainImageUrl = image.mainImageUrl, !mainImageUrl.isEmpty, let url = URL(string: mainImageUrl) {
            popupImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "defaultImage"),
                options: [.transition(.fade(0.2))],
                completionHandler: { result in
                    switch result {
                    case .success(_):
                        print("이미지 로딩 성공: \(url)")
                    case .failure(let error):
                        print("이미지 로딩 실패: \(url), 에러: \(error.localizedDescription)")
                        self.popupImageView.image = UIImage(named: "defaultImage")
                    }
                }
            )
        } else {
            popupImageView.image = UIImage(named: "defaultImage")
            print("기본 이미지로 설정")
        }
    }
}
