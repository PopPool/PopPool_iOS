//
//  ProfileEditCategoryBottomSheetVC.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/17/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class ProfileEditCategoryBottomSheetVC: ModalViewController {
    
    // MARK: - Components
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private let headerView: HeaderViewCPNT = {
        let view = HeaderViewCPNT(
            title: "관심 카테고리를 선택해주세요",
            style: .icon(UIImage(named: "xmark_signUp"))
        )
        view.leftBarButton.isHidden = true
        view.leftTrailingView.isHidden = true
        view.titleLabel.textAlignment = .left
        view.titleLabel.font = .KorFont(style: .bold, size: 18)
        return view
    }()
    
    private let collectionView = InterestSelectedView()
    
    private let saveButton = ButtonCPNT(type: .primary, title: "저장", disabledTitle: "저장")
    
    // MARK: - Properties
    private let viewModel: ProfileEditCategoryBottomSheetVM
    private let disposeBag = DisposeBag()

    init(viewModel: ProfileEditCategoryBottomSheetVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCycle
extension ProfileEditCategoryBottomSheetVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraints()
        bind()
    }
}

// MARK: - SetUp
private extension ProfileEditCategoryBottomSheetVC {
    
    func setUp() {

    }
    
    func setUpConstraints() {
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height / 4)
        }
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(Constants.spaceGuide.medium100)
        }
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Constants.spaceGuide.medium100)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        stackView.addArrangedSubview(collectionView)
        stackView.addArrangedSubview(saveButton)
        setContent(content: contentView)
    }
    
    func bind() {
        headerView.rightBarButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.dismissBottomSheet()
            }
            .disposed(by: disposeBag)
        
        let input = ProfileEditCategoryBottomSheetVM.Input(
            selectedCategory: collectionView.selectedList,
            saveButtonTapped: saveButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        output.categoryList
            .skip(1)
            .withUnretained(self)
            .subscribe { (owner, list) in
                let selectList = owner.viewModel.originSelectedCategory.map{ IndexPath(row: Int($0) - 1, section: 0)}
                owner.collectionView.selectedList.accept(selectList)
                owner.collectionView.categoryList.accept(list.map{ $0.category })
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
