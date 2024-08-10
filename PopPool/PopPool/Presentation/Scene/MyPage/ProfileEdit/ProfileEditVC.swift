//
//  ProfileEditVC.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/10/24.
//

import UIKit

import SnapKit

final class ProfileEditVC: BaseViewController {
    // MARK: - Components
    
    private let headerView: HeaderViewCPNT = {
        let view = HeaderViewCPNT(title: "프로필 설정", style: .text(""))
        return view
    }()
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let profileImageView: ProfileCircleImageViewCPNT = {
        let view = ProfileCircleImageViewCPNT(size: .large)
        view.image = UIImage(named: "Profile_Logo")
        return view
    }()
    private let profileImageEditButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "camera"), for: .normal)
        button.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 16
        button.backgroundColor = .systemBackground
        return button
    }()
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "별명"
        label.font = .KorFont(style: .regular, size: 13)
        return label
    }()
    private let nickNameTextField: ValidationTextFieldCPNT = ValidationTextFieldCPNT(
        placeHolder: "닉네임을 입력해주세요.",
        limitTextCount: 10
    )
    private let introLabel: UILabel = {
        let label = UILabel()
        label.text = "자기소개"
        label.font = .KorFont(style: .regular, size: 13)
        return label
    }()
    private let introTextField: DynamicTextViewCPNT = {
        var view = DynamicTextViewCPNT(placeholder: "자기소개", textLimit: 30)
        return view
    }()
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.text = "맞춤정보"
        label.font = .KorFont(style: .bold, size: 16)
        return label
    }()
    private let categoryView: ListMenuViewCPNT = {
        let view = ListMenuViewCPNT(title: "관심 카테고리", style: .normal)
        view.rightLabel.text = "패션 외 2개"
        view.rightLabel.textColor = .g400
        return view
    }()
    private let userInfoView: ListMenuViewCPNT = {
        let view = ListMenuViewCPNT(title: "사용자 정보", style: .normal)
        view.rightLabel.text = "남성 28세"
        view.rightLabel.textColor = .g400
        return view
    }()
    private let saveButton: ButtonCPNT = {
        let button = ButtonCPNT(type: .primary, title: "저장", disabledTitle: "저장")
        return button
    }()
}

// MARK: - LifeCycle
extension ProfileEditVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
    }
}

// MARK: - SetUp
private extension ProfileEditVC {
    func setUp() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .g50
    }
    
    func setUpConstraints() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top)
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.spaceGuide.medium300)
            make.centerX.equalToSuperview()
        }
        contentView.addSubview(profileImageEditButton)
        profileImageEditButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(profileImageView)
            make.size.equalTo(32)
        }
        contentView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(Constants.spaceGuide.medium400)
            make.height.equalTo(20)
            make.leading.equalToSuperview().inset(20)
        }
        contentView.addSubview(nickNameTextField)
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        contentView.addSubview(introLabel)
        introLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(Constants.spaceGuide.small300)
            make.leading.equalToSuperview().inset(20)
        }
        contentView.addSubview(introTextField)
        introTextField.snp.makeConstraints { make in
            make.top.equalTo(introLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        contentView.addSubview(sectionLabel)
        sectionLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.top.equalTo(introTextField.snp.bottom).offset(27)
            make.leading.equalToSuperview().inset(20)
        }
        contentView.addSubview(categoryView)
        categoryView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(sectionLabel.snp.bottom).offset(16)
        }
        contentView.addSubview(userInfoView)
        userInfoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(categoryView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
    }
}
