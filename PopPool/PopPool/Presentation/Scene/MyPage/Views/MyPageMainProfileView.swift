//
//  MyPageMainProfileView.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/8/24.
//

import UIKit
import SnapKit

final class MyPageMainProfileView: UIView {
    
    // MARK: - Components
    private var containerView: UIView = UIView()
    private var backGroundImageView: UIImageView = UIImageView()
    private let contentView: UIView = UIView()
    private let profileImageView = ProfileImageViewCPNT(size: .midium)
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .light, size: 11)
        label.text = "가고 싶은 곳을 다니고, 입고 싶은 것을 입어요"
        return label
    }()
    
    private let bottomHoleView: UIView = UIView()
    private let bottomHoleBlockView: UIView = UIView()
    
    // MARK: - Properties
    private var containerViewHeight: Constraint?
    private var imageViewHeight: Constraint?
    private var imageViewBottom: Constraint?
    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
        setUpMask()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - SetUp
private extension MyPageMainProfileView {
    
    func setUp() {
//        backGroundImageView.image = UIImage(systemName: "folder")
//        backGroundImageView.image = UIImage(named: "TestImage")
        backGroundImageView.clipsToBounds = true
        backGroundImageView.contentMode = .scaleAspectFill
        // 블러 처리
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        backGroundImageView.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bottomHoleView.backgroundColor = .systemBackground
        bottomHoleBlockView.backgroundColor = .systemBackground
    }
    
    func setUpConstraints() {
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            containerViewHeight = make.height.equalToSuperview().constraint
        }
        containerView.addSubview(backGroundImageView)
        backGroundImageView.snp.makeConstraints { make in
            make.width.equalTo(containerView)
            imageViewBottom = make.bottom.equalTo(containerView).constraint
            imageViewHeight = make.height.equalTo(containerView).constraint
        }
        containerView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 40)
            make.center.equalToSuperview()
        }
        containerView.addSubview(bottomHoleView)
        bottomHoleView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(49)
        }
        containerView.addSubview(bottomHoleBlockView)
        bottomHoleBlockView.snp.makeConstraints { make in
            make.edges.equalTo(bottomHoleView)
        }
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(88)
        }
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-25)
        }
    }
    
    func setUpMask() {
        // Bottom Hole Mask 생성
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: bounds.midX, y: bottomHoleView.bounds.midY),
                    radius: 12,
                    startAngle: 0.0,
                    endAngle: 2.0 * .pi,
                    clockwise: false)
        let size: CGSize = .init(width: frame.width, height: frame.height)
        path.addRect(CGRect(origin: .zero, size: size))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        bottomHoleView.layer.mask = maskLayer
    }
}

// MARK: - Methods
extension MyPageMainProfileView {
    func scrollViewDidScroll(scrollView: UIScrollView, alpha: Double) {
        //stretch view 제약 설정
        containerViewHeight?.update(offset: scrollView.contentInset.top)
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom?.update(offset: offsetY >= 0 ? 0 : -offsetY / 2)
        imageViewHeight?.update(offset: max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top))
        bottomHoleBlockView.alpha = alpha
    }
}
