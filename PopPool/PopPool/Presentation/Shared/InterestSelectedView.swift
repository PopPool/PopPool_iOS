//
//  InterestSelectedView.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class InterestSelectedView: UIView {
    
    // MARK: - Components
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
    
    let selectedList: BehaviorRelay<[IndexPath]> = .init(value: [])
    
    let categoryList: BehaviorRelay<[String]> = .init(value: [])
    
    // MARK: - init
    init() {
        super.init(frame: .zero)
        setUp()
        bind()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension InterestSelectedView {
    func setUp() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    
    func setUpConstraints() {
        self.addSubview(categoryCollectionView)
        categoryCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 데이터 바인딩 메서드
    func bind() {
        categoryList
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.categoryCollectionView.reloadData()
                let selectedList = owner.selectedList.value
                for i in selectedList {
                    owner.categoryCollectionView.selectItem(at: i, animated: true, scrollPosition: .top)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension InterestSelectedView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeChipCell.identifier, for: indexPath) as? LargeChipCell else {
            return UICollectionViewCell()
        }
        cell.injectionWith(input: .init(title: categoryList.value.sorted()[indexPath.row])) // 내려받은 데이터를 ㄱ~ㅎ 순으로 처리하기 위해 sorted() 메서드 추가 반영
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = LargeChipCell()
        let title = categoryList.value[indexPath.row]
        cell.injectionWith(input: .init(title: title))
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
        if let targetIndex = selectedListValue.firstIndex(of: indexPath) {
            selectedListValue.remove(at: targetIndex)
            selectedList.accept(selectedListValue)
        }
    }
}
