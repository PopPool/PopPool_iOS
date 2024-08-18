//
//  ProfileEditUserDataBottomSheetVM.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/17/24.
//

import UIKit

import RxSwift
import RxCocoa

final class ProfileEditUserDataBottomSheetVM: ViewModelable {
    
    struct UserData {
        var gender: String
        var age: Int32
    }
    
    struct Input {
        var genderSelected: Observable<String>
        var ageSelected: Observable<Int>
        var saveButtonTapped: ControlEvent<Void>
    }
    struct Output {
        var setOrignUserData: BehaviorRelay<UserData>
        var saveButtonIsActive: BehaviorRelay<Bool>
    }
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var orignUserData: BehaviorRelay<UserData>
    var changeUserData: BehaviorRelay<UserData>
    var userUseCase: UserUseCase
    var saveButtonIsActive: BehaviorRelay<Bool> = .init(value: false)
    
    // MARK: - init
    init(orignUserData: UserData, userUseCase: UserUseCase) {
        self.orignUserData = BehaviorRelay(value: orignUserData)
        self.changeUserData = BehaviorRelay(value: orignUserData)
        self.userUseCase = userUseCase
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        
        input.genderSelected
            .withUnretained(self)
            .subscribe { (owner, gender) in
                var userData = owner.changeUserData.value
                userData.gender = gender
                owner.changeUserData.accept(userData)
            }
            .disposed(by: disposeBag)
        
        input.ageSelected
            .withUnretained(self)
            .subscribe { (owner, age) in
                var userData = owner.changeUserData.value
                userData.age = Int32(age)
                owner.changeUserData.accept(userData)
            }
            .disposed(by: disposeBag)
        
        input.saveButtonTapped
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.userUseCase.updateMyTailoredInfo(
                    userId: Constants.userId,
                    gender: owner.changeUserData.value.gender,
                    age: owner.changeUserData.value.age
                )
                .subscribe {
                    ToastMSGManager.createToast(message: "수정사항을 반영했어요")
                    owner.saveButtonIsActive.accept(false)
                } onError: { error in
                    ToastMSGManager.createToast(message: "수정사항을 반영하지 못했어요")
                }
                .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        changeUserData
            .withUnretained(self)
            .subscribe { (owner, changeUserData) in
                owner.saveButtonIsActive.accept(owner.isChange())
            }
            .disposed(by: disposeBag)
        
        return Output(
            setOrignUserData: orignUserData,
            saveButtonIsActive: saveButtonIsActive
        )
    }
    
    func isChange() -> Bool {
        let changeData = changeUserData.value
        let originData = orignUserData.value        
        if originData.gender == changeData.gender {
            if originData.age == changeData.age {
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
}
