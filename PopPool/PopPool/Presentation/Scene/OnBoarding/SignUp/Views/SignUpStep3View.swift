//
//  SignUpStep3View.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/27/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpStep3View: UIStackView {
    
    // MARK: - Components
    private let topSpacingView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "관심이 있는 카테고리를 선택해주세요"
        label.font = .KorFont(style: .bold, size: 16)
        label.textColor = .g1000
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "최대 5개까지 선택할 수 있어요."
        label.font = .KorFont(style: .regular, size: 12)
        label.textColor = .g1000
        return label
    }()
    
    private let middleSpacingView = UIView()

    private let categoryCollectionView: UICollectionView = {
        let layout = TagsLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(LargeChipCell.self, forCellWithReuseIdentifier: LargeChipCell.identifier)
        view.allowsMultipleSelection = true
        
        return view
    }()
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    private let selectedList: BehaviorRelay<[IndexPath]> = .init(value: [])
    
    private let categoryList: BehaviorRelay<[String]> = .init(value: [])

    // MARK: - init
    init() {
        super.init(frame: .zero)
        setUp()
        setUpConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension SignUpStep3View {
    
    /// 초기 설정 메서드
    func setUp() {
        self.axis = .vertical
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    
    /// 제약 조건 설정 메서드
    func setUpConstraints() {
        topSpacingView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.medium400)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        subLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        middleSpacingView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.medium200)
        }
        self.addArrangedSubview(topSpacingView)
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(subLabel)
        self.addArrangedSubview(middleSpacingView)
        self.addArrangedSubview(categoryCollectionView)
    }
    
    /// 데이터 바인딩 메서드
    func bind() {
        categoryList
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.categoryCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}
// MARK: - Methods
extension SignUpStep3View {
    
    /// 선택된 리스트를 가져오는 메서드
    /// - Returns: 선택된 카테고리 리스트를 반환하는 옵저버블
    func fetchSelectedList() -> Observable<[String]> {
        return selectedList.map { indexPathList in
            return indexPathList.compactMap { indexPath in
                return self.categoryList.value[indexPath.row]
            }
        }
    }
    
    /// 카테고리 리스트를 설정하는 메서드
    /// - Parameter list: 카테고리 리스트
    func setCategoryList(list: [String]) {
        categoryList.accept(list)
    }
}

extension SignUpStep3View: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeChipCell.identifier, for: indexPath) as? LargeChipCell else {
            return UICollectionViewCell()
        }
        cell.configure(title: categoryList.value[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = LargeChipCell()
        let title = categoryList.value[indexPath.row]
        cell.configure(title: title)
        return cell.adjustCellSize(title: title)
    }
    
    /// 셀이 선택되었을 때의 동작 정의
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let limitSelectedCount = 5
        let selectedListValue = selectedList.value
        if selectedListValue.count >= limitSelectedCount {
            collectionView.deselectItem(at: indexPath, animated: false)
            ToastMSGManager.createToast(message: "최대 5개 까지 선택할 수 있어요")
        } else {
            selectedList.accept(selectedListValue + [indexPath])
        }
    }
    
    /// 셀이 선택 해제되었을 때의 동작 정의
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        var selectedListValue = selectedList.value
        let targetIndex = selectedListValue.firstIndex(of: indexPath)!
        selectedListValue.remove(at: targetIndex)
        selectedList.accept(selectedListValue)
    }
}
