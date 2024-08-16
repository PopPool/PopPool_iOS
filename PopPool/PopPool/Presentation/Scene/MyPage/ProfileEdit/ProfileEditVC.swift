//
//  ProfileEditVC.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/10/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

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
    private let instagramLabel: UILabel = {
        let label = UILabel()
        label.text = "인스타그램 링크"
        label.font = .KorFont(style: .regular, size: 13)
        return label
    }()
    private let instagramTextField: BaseTextFieldCPNT = {
        let textField = BaseTextFieldCPNT(
            placeHolder: "인스타그램 링크",
            description: "인스타그램 코멘트와 마이페이지에 ID가 노출됩니다"
        )
        return textField
    }()
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
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Properties
    
    private let viewModel: ProfileEditVM
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: ProfileEditVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCycle
extension ProfileEditVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
        bind()
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
        contentView.addSubview(instagramLabel)
        instagramLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(Constants.spaceGuide.small300)
            make.height.equalTo(20)
            make.leading.equalToSuperview().inset(20)
        }
        contentView.addSubview(instagramTextField)
        instagramTextField.snp.makeConstraints { make in
            make.top.equalTo(instagramLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        contentView.addSubview(introLabel)
        introLabel.snp.makeConstraints { make in
            make.top.equalTo(instagramTextField.snp.bottom).offset(Constants.spaceGuide.small300)
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
    
    func bind() {
        // HeaderView BackButton Tapped
        headerView.leftBarButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        let input = ProfileEditVM.Input(
            viewWillAppear: self.rx.viewWillAppear,
            nickNameState: nickNameTextField.stateObserver.asObservable(),
            nickNameButtonTapped: nickNameTextField.checkValidationButton.rx.tap,
            instaLinkText: instagramTextField.textField.rx.text.orEmpty,
            introText: introTextField.textViewStateObserver,
            saveButtonTapped: saveButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.originUserData
            .withUnretained(self)
            .subscribe { (owner, originData) in
                owner.nickNameTextField.textField.text = originData.nickname
                owner.nickNameTextField.myNickName = originData.nickname
                owner.nickNameTextField.stateObserver.onNext(.myNickName)
                owner.nickNameTextField.setTextLimit(text: originData.nickname)
                owner.instagramTextField.textField.text = originData.instagramId
                owner.introTextField.textView.text = originData.intro
                let categoryString = originData.interestCategoryList.count == 0 ? "" : originData.interestCategoryList.count == 1 ? originData.interestCategoryList.first!.interestCategory : originData.interestCategoryList.first!.interestCategory + "외 \(originData.interestCategoryList.count - 1) 개"
                owner.categoryView.rightLabel.text = categoryString
                owner.userInfoView.rightLabel.text = originData.gender + String(originData.age) + "세"
            }
            .disposed(by: disposeBag)
        output.nickNameState
            .withUnretained(self)
            .subscribe { (owner, state) in
                owner.nickNameTextField.stateObserver.onNext(state)
            }
            .disposed(by: disposeBag)
        
        output.saveButtonIsActive
            .withUnretained(self)
            .subscribe { (owner, isActive) in
                print(isActive)
                owner.saveButton.isEnabled = isActive
            }
            .disposed(by: disposeBag)
    }
}
