//
//  ProfileEditVM.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/13/24.
//

import Foundation

import RxSwift
import RxCocoa

final class ProfileEditVM: ViewModelable {

    struct Input {
        
    }
    struct Output {
        var originUserData: BehaviorRelay<GetProfileResponse>
    }
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    private var originUserData: BehaviorRelay<GetProfileResponse>
    // MARK: - init
    init(originUserData: GetProfileResponse) {
        self.originUserData = BehaviorRelay(value: originUserData)
    }
    
    // MARK: - Methods
    func transform(input: Input) -> Output {
        return Output(
            originUserData: originUserData
        )
    }
}
