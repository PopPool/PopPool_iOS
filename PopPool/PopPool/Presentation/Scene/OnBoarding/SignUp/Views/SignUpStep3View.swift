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

    private let categoryCollectionView = InterestSelectedView()
    
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
}
// MARK: - Methods
extension SignUpStep3View {
    
    /// 선택된 리스트를 가져오는 메서드
    /// - Returns: 선택된 카테고리 리스트를 반환하는 옵저버블
    func fetchSelectedList() -> Observable<[Int]> {
        return categoryCollectionView.selectedList.map { indexPathList in
            return indexPathList.map({ $0.row })
        }
    }
    
    /// 카테고리 리스트를 설정하는 메서드
    /// - Parameter list: 카테고리 리스트
    func setCategoryList(list: [String]) {
        categoryCollectionView.categoryList.accept(list)
    }
}
