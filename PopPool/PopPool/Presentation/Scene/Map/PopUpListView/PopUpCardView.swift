// PopupCardView.swift
import UIKit
import Kingfisher

class PopupCardView: UIView {
    var store: MapPopUpStore?

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let addressLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 4
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(categoryLabel)
        addSubview(addressLabel)
        addSubview(dateLabel)
        
        imageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(12)
            make.width.equalTo(76)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .lightGray
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 2
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }
        categoryLabel.font = .systemFont(ofSize: 12)
        categoryLabel.textColor = .gray
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }
        addressLabel.font = .systemFont(ofSize: 12)
        addressLabel.textColor = .gray
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.lessThanOrEqualToSuperview().inset(12)
        }
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .gray
    }
    
    func configure(with store: MapPopUpStore) {
        // 팝업스토어명 (22자 제한)
        let truncatedName = store.name.count > 22 ? String(store.name.prefix(22)) + "..." : store.name
        titleLabel.text = truncatedName
        
        // 카테고리
        categoryLabel.text = store.category
        
        // 지역 (시 / 구까지 노출)
        let addressComponents = store.address.components(separatedBy: " ")
        if addressComponents.count >= 2 {
            addressLabel.text = "\(addressComponents[0]) \(addressComponents[1])"
        } else {
            addressLabel.text = store.address
        }
        
        // 일자 (YYYY. MM. DD ~ YYYY. MM. DD 형식으로 표시)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "YYYY. MM. dd"
        
        if let startDate = dateFormatter.date(from: store.startDate),
           let endDate = dateFormatter.date(from: store.endDate) {
            let startDateString = outputFormatter.string(from: startDate)
            let endDateString = outputFormatter.string(from: endDate)
            dateLabel.text = "\(startDateString) ~ \(endDateString)"
        } else {
            dateLabel.text = "날짜 정보 없음"
        }
    }
    
    // PopupCardView에 맞게 이미지 로딩을 처리
    func configureImage(with image: PopUpStoreImage) {
        if let mainImageUrl = image.mainImageUrl, !mainImageUrl.isEmpty, let url = URL(string: mainImageUrl) {
            print("이미지 URL: \(url)")
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "defaultImage"),
                options: [.transition(.fade(0.2))],
                completionHandler: { result in
                    switch result {
                    case .success(_):
                        print("이미지 로딩 성공: \(url)")
                    case .failure(let error):
                        print("이미지 로딩 실패: \(url), 에러: \(error.localizedDescription)")
                        self.imageView.image = UIImage(named: "defaultImage")
                    }
                }
            )
        } else {
            print("유효하지 않은 이미지 URL 또는 빈 값")
            imageView.image = UIImage(named: "placeholder")
        }
    }
}
