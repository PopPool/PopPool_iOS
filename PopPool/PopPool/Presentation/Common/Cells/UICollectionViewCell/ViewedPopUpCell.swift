//
//  ViewedPopUpCell.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/27/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ViewedPopUpCell: UICollectionViewCell {
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
        label.font = .EngFont(style: .regular, size: 11)
        label.textColor = .g400
        label.textAlignment = .left
        return label
    }()
    private let popUpTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .bold, size: 12)
        label.textColor = .g1000
        label.textAlignment = .left
        return label
    }()

    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "bookmark"), for: .normal)
        return button
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpShadow()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.layer.mask = nil
    }
}

// MARK: - SetUp
private extension ViewedPopUpCell {
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
            make.height.equalTo(190)
        }
        contentView.addSubview(infoContentView)
        infoContentView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        infoContentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(15)
        }
        infoContentView.addSubview(popUpTitleLabel)
        popUpTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(17)
        }
        imageView.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.size.equalTo(20)
        }
    }
    
    func setUpHole() {
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: bounds.minX, y: 190),
                    radius: 6,
                    startAngle: 0.0,
                    endAngle: 2.0 * .pi,
                    clockwise: false)
        path.addArc(center: CGPoint(x: bounds.maxX, y: 190),
                    radius: 6,
                    startAngle: 0.0,
                    endAngle: 2.0 * .pi,
                    clockwise: false)
        let size: CGSize = .init(width: frame.width, height: frame.height)
        path.addRect(CGRect(origin: .zero, size: size))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        contentView.layer.mask = maskLayer
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
}

extension ViewedPopUpCell : Cellable {

    struct Input {
        var date: String
        var title: String
    }
    
    struct Output {
        var bookmarkButtonTap: ControlEvent<Void>
    }
    
    func injectionWith(input: Input) {
        dateLabel.text = input.date
        popUpTitleLabel.text = input.title
        imageView.image = UIImage(named: "lightLogo")
        setUpHole()
    }
    
    func getOutput() -> Output {
        return Output(
            bookmarkButtonTap: bookmarkButton.rx.tap
        )
    }
}
