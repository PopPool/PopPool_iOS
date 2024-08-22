//
//  ProfileEditCategoryBottomSheetVM.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/17/24.
//

import Foundation

import RxSwift
import RxCocoa

final class ProfileEditCategoryBottomSheetVM: ViewModelable {
    
    struct Input {
        var selectedCategory: BehaviorRelay<[IndexPath]>
        var saveButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        var categoryList: BehaviorRelay<[Category]>
        var saveButtonIsActive: BehaviorRelay<Bool>
    }
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    private var categoryList: BehaviorRelay<[Category]> = .init(value: [])
    
    var originSelectedCategory: [Int64] = []
    
    private var changeSelectedCategory: BehaviorRelay<[IndexPath]>
    
    private var signUpUseCase: SignUpUseCase = AppDIContainer.shared.resolve(type: SignUpUseCase.self)
    
    private var userUseCase: UserUseCase
    
    private var saveButtonIsActive: BehaviorRelay<Bool> = .init(value: false)
    
    init(selectedCategory: [Int64], userUseCase: UserUseCase) {
        self.originSelectedCategory = selectedCategory
        self.changeSelectedCategory = .init(value: selectedCategory.map { IndexPath(row: Int($0) - 1, section: 0)})
        self.userUseCase = userUseCase
    }
    
    func transform(input: Input) -> Output {
        signUpUseCase.fetchCategoryList()
            .withUnretained(self)
            .subscribe { (owner, list) in
                owner.categoryList.accept(list)
            }
            .disposed(by: disposeBag)
        
        changeSelectedCategory
            .withUnretained(self)
            .subscribe { (owner, list) in
                let changeList = list.map { Int64($0.row + 1) }.sorted()
                let originSorted = owner.originSelectedCategory.sorted()
                
                if changeList == originSorted {
                    owner.saveButtonIsActive.accept(false)
                } else {
                    if changeList.count == 0 {
                        owner.saveButtonIsActive.accept(false)
                    } else {
                        owner.saveButtonIsActive.accept(true)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        
        input.selectedCategory
            .withUnretained(self)
            .subscribe { (owner, list) in
                owner.changeSelectedCategory.accept(list)
            }
            .disposed(by: disposeBag)
        
        input.saveButtonTapped
            .withUnretained(self)
            .subscribe { (owner, _) in
                let data = owner.getInterestData(changeList: owner.changeSelectedCategory.value)
                owner.userUseCase.updateMyInterest(
                    userId: Constants.userId,
                    interestsToAdd: data[0],
                    interestsToDelete: data[1],
                    interestsToKeep: data[2]
                )
                .subscribe {
                    ToastMSGManager.createToast(message: "수정사항을 반영했어요")
                    owner.saveButtonIsActive.accept(false)
                    owner.originSelectedCategory = owner.changeSelectedCategory.value.map { Int64($0.row) }
                } onError: { error in
                    ToastMSGManager.createToast(message: "수정사항을 반영하지 못했어요")
                }
                .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        return Output(
            categoryList: categoryList,
            saveButtonIsActive: saveButtonIsActive
        )
    }
    
    func getInterestData(changeList: [IndexPath]) -> [[Int64]] {
        let changeListMap = changeList.map { Int64($0.row) + 1 }
        var deleteResult:[Int64] = originSelectedCategory
        var addResult:[Int64] = []
        var keepResult:[Int64] = []
        for i in changeListMap {
            if originSelectedCategory.contains(i) {
                keepResult.append(i)
            } else {
                addResult.append(i)
            }
            if let removeIndex = deleteResult.firstIndex(of: i) {
                deleteResult.remove(at: removeIndex)
            }
        }
        return [addResult,deleteResult,keepResult]
    }
}
