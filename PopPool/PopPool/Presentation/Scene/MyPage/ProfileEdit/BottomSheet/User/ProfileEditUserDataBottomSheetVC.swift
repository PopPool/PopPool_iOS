//
//  ProfileEditUserDataBottomSheetVC.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/17/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class ProfileEditUserDataBottomSheetVC: ModalViewController {
    
    // MARK: - Components
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private let headerView: HeaderViewCPNT = {
        let view = HeaderViewCPNT(
            title: "사용자 정보를 설정해주세요",
            style: .icon(UIImage(named: "xmark_signUp"))
        )
        view.leftBarButton.isHidden = true
        view.leftTrailingView.isHidden = true
        view.titleLabel.textAlignment = .left
        view.titleLabel.font = .KorFont(style: .bold, size: 18)
        return view
    }()
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "성별"
        label.textColor = .g1000
        label.font = .KorFont(style: .regular, size: 13)
        return label
    }()
    
    private let genderLabelBottomspacingView = SpacingFactory.createSpace(size: Constants.spaceGuide.micro200)
    
    lazy var genderSegmentedControl: SegmentedControlCPNT = SegmentedControlCPNT(
        type: .base,
        segments: self.genderList,
        selectedSegmentIndex: self.genderList.firstIndex(of: self.viewModel.orignUserData.value.gender) ?? 0
    )
    private let genderSegmentedControlBottomSpacingView = SpacingFactory.createSpace(size: 36)
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "나이"
        label.textColor = .g1000
        label.font = .KorFont(style: .regular, size: 13)
        return label
    }()
    private let ageLabelBottomSpacingView = SpacingFactory.createSpace(size: Constants.spaceGuide.micro200)
    
    let ageButton = SignUpAgeSelectedButton()
    
    private let bottomSpacingView = SpacingFactory.createSpace(size: 36)
    
    private let saveButton = ButtonCPNT(type: .primary, title: "저장", disabledTitle: "저장")
    
    // MARK: - Properties
    private let viewModel: ProfileEditUserDataBottomSheetVM
    
    let genderList: [String] = ["남성", "여성", "선택안함"]
    
    private let ageSelected: PublishSubject<Int> = .init()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - init
    init(viewModel: ProfileEditUserDataBottomSheetVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileEditUserDataBottomSheetVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
        bind()
    }
}

extension ProfileEditUserDataBottomSheetVC {
    func setUp() {
        
    }
    
    func setUpConstraints() {
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.spaceGuide.medium100)
            make.leading.trailing.equalToSuperview()
        }
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(32)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        ageButton.snp.makeConstraints { make in
            make.height.equalTo(72)
        }
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        contentStackView.addArrangedSubview(genderLabel)
        contentStackView.addArrangedSubview(genderLabelBottomspacingView)
        contentStackView.addArrangedSubview(genderSegmentedControl)
        contentStackView.addArrangedSubview(genderSegmentedControlBottomSpacingView)
        contentStackView.addArrangedSubview(ageLabel)
        contentStackView.addArrangedSubview(ageLabelBottomSpacingView)
        contentStackView.addArrangedSubview(ageButton)
        contentStackView.addArrangedSubview(bottomSpacingView)
        contentStackView.addArrangedSubview(saveButton)
        setContent(content: contentView)
    }
    
    func bind() {
        
        headerView.rightBarButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.dismissBottomSheet()
            }
            .disposed(by: disposeBag)
        
        ageButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                let vc = AgeSelectModalVC(ageRange: (14...100), selectIndex: Int(owner.viewModel.changeUserData.value.age - 14))
                owner.presentModalViewController(viewController: vc)
                vc.selectIndexRelayObserver
                    .subscribe(onNext: { index in
                        owner.ageSelected.onNext(index + 14)
                        owner.ageButton.setAge(age: index + 14)
                    })
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        let input = ProfileEditUserDataBottomSheetVM.Input(
            genderSelected: genderSegmentedControl.rx.selectedSegmentIndex.map { [weak self] index in self?.genderList[index] ?? "남성" },
            ageSelected: ageSelected,
            saveButtonTapped: saveButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.setOrignUserData
            .withUnretained(self)
            .subscribe { (owner, data) in
                owner.ageButton.setAge(age: Int(data.age))
                let index = owner.genderList.firstIndex(of: owner.viewModel.orignUserData.value.gender) ?? 0
                owner.genderSegmentedControl.selectedSegmentIndex = index
            }
            .disposed(by: disposeBag)
        
        output.saveButtonIsActive
            .withUnretained(self)
            .subscribe { (owner, isActive) in
                owner.saveButton.isEnabled = isActive
            }
            .disposed(by: disposeBag)
    }
}
