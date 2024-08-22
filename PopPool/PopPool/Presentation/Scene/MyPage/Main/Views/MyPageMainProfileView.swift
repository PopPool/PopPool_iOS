//
//  MyPageMainProfileView.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/8/24.
//

import UIKit

import SnapKit
import Kingfisher

final class MyPageMainProfileView: UIView {
    
    // MARK: - Components
    private var containerView: UIView = UIView()
    private var backGroundImageView: UIImageView = UIImageView()
    private let contentView: UIView = UIView()
    private let profileImageView = ProfileCircleImageViewCPNT(size: .midium)
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .light, size: 11)
        return label
    }()
    private let labelStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .bold, size: 16)
        label.textColor = .g1000
        return label
    }()
    private let instagramLabel: UILabel = {
        let label = UILabel()
        label.font = .EngFont(style: .regular, size: 14)
        label.textColor = .g1000
        return label
    }()
    private let bottomHoleView: UIView = UIView()
    private let bottomHoleBlockView: UIView = UIView()
    let loginButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        return button
    }()
    private let loginButtonLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .medium, size: 13)
        label.text = "로그인/회원가입"
        label.textColor = .w100
        return label
    }()
    private let loginDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "나에게 맞는\n팝업스토어 만나러 가기"
        label.numberOfLines = 0
        label.textColor = .w100
        label.font = .KorFont(style: .bold, size: 18)
        return label
    }()
    // MARK: - Properties
    private var containerViewHeight: Constraint?
    private var imageViewHeight: Constraint?
    private var imageViewBottom: Constraint?
    private var contentViewY: Constraint?
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraints()
        setUpMask()
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - SetUp
private extension MyPageMainProfileView {
    
    func setUp() {
        backGroundImageView.clipsToBounds = true
        backGroundImageView.contentMode = .scaleAspectFill
        // 블러 처리
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        backGroundImageView.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
            make.height.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 40)
            make.centerX.equalToSuperview()
            contentViewY =  make.centerY.equalToSuperview().constraint
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
    }
    
    func setUpProfileView() {
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
        nickNameLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        instagramLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        labelStackView.addArrangedSubview(nickNameLabel)
        labelStackView.addArrangedSubview(instagramLabel)
        
        contentView.addSubview(labelStackView)
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
    }
    
    func setUpMask() {
        bottomHoleView.backgroundColor = .systemBackground
        bottomHoleBlockView.backgroundColor = .systemBackground
        
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
        self.layoutSubviews()
    }
    
    func setUpLoginView() {
        self.backGroundImageView.backgroundColor = .g800
        loginButton.addSubview(loginButtonLabel)
        loginButtonLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(8)
            make.height.equalTo(20)
            make.top.bottom.equalToSuperview().inset(6)
        }
        contentView.addSubview(loginButton)
        loginButton.backgroundColor = .w10
        loginButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(97)
            make.leading.equalToSuperview()
        }
        contentView.addSubview(loginDescriptionLabel)
        loginDescriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(loginButton.snp.top).offset(-16)
            make.leading.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}

// MARK: - Methods
extension MyPageMainProfileView: InputableView {

    struct Input {
        var isLogin: Bool
        var nickName: String?
        var instagramId: String?
        var intro: String?
        var profileImage: URL?
    }
    
    func injectionWith(input: Input) {
        if input.isLogin {
            setUpProfileView()
            if let profileImageViewURL = input.profileImage {
                backGroundImageView.kf.setImage(with: profileImageViewURL)
                profileImageView.kf.setImage(with: profileImageViewURL)
            } else {
                self.backGroundImageView.image = UIImage(systemName: "folder")
                self.profileImageView.image = UIImage(systemName: "folder")
            }
            nickNameLabel.text = input.nickName
            instagramLabel.text = input.instagramId
            descriptionLabel.text = input.intro
        } else {
            setUpLoginView()
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView, alpha: Double) {
        //stretch view 제약 설정
        containerViewHeight?.update(offset: scrollView.contentInset.top)
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom?.update(offset: offsetY >= 0 ? 0 : -offsetY / 2)
        imageViewHeight?.update(offset: max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top))
        bottomHoleBlockView.alpha = alpha
        //ContentView 인터렉션
        contentViewY?.update(offset: alpha * 300)
    }
}
