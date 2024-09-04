//
//  SavedPopUpCell.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/26/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Kingfisher

final class SavedPopUpCell: UICollectionViewCell {
    // MARK: - Components
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        return view
    }()
    private let infoContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .w100
        return view
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .EngFont(style: .regular, size: 13)
        label.textColor = .g1000
        label.textAlignment = .center
        return label
    }()
    private let popUpTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .bold, size: 16)
        label.textColor = .g1000
        label.textAlignment = .center
        return label
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 14)
        label.textColor = .g400
        label.textAlignment = .center
        return label
    }()
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "bookmark"), for: .normal)
        return button
    }()
    var disposeBag = DisposeBag()
    
    var buttonIsHidden = false
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpShadow()
        setUpConstraints()
        setUpHole()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

// MARK: - SetUp
private extension SavedPopUpCell {
    func setUp() {
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    func setUpShadow() {
        let shadows = UIView()
        shadows.frame = contentView.frame
        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 0)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0.008, green: 0.137, blue: 0.392, alpha: 0.08).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 8
        layer0.shadowOffset = CGSize(width: 0, height: 1)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)
    }
    func setUpConstraints() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(423)
        }
        contentView.addSubview(infoContentView)
        infoContentView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        infoContentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(24)
            make.height.equalTo(18)
        }
        infoContentView.addSubview(popUpTitleLabel)
        popUpTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        infoContentView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(popUpTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        imageView.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
            make.size.equalTo(36)
        }
    }
    
    func setUpHole() {
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: bounds.minX, y: 423),
                    radius: 12,
                    startAngle: 0.0,
                    endAngle: 2.0 * .pi,
                    clockwise: false)
        path.addArc(center: CGPoint(x: bounds.maxX, y: 423),
                    radius: 12,
                    startAngle: 0.0,
                    endAngle: 2.0 * .pi,
                    clockwise: false)
        let size: CGSize = .init(width: frame.width, height: frame.height)
        path.addRect(CGRect(origin: .zero, size: size))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        contentView.layer.mask = maskLayer
    }
}

extension SavedPopUpCell : Cellable {
    
    struct Input {
        var date: String
        var title: String
        var address: String
        var imageURL: URL?
        var buttonIsHidden: Bool
    }
    
    struct Output {
        var bookmarkButtonTap: ControlEvent<Void>
    }
    
    func injectionWith(input: Input) {
        dateLabel.text = input.date
        popUpTitleLabel.text = input.title
        addressLabel.text = input.address
        bookmarkButton.isHidden = input.buttonIsHidden
        if let url = input.imageURL {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url) { [weak self] result in
                switch result {
                case .success:
                    print("ImageLoad Success")
                case .failure:
                    self?.imageView.image = UIImage(named: "defaultLogo")
                }
            }
        }
    }
    
    func getOutput() -> Output {
        return Output(
            bookmarkButtonTap: bookmarkButton.rx.tap
        )
    }
}
