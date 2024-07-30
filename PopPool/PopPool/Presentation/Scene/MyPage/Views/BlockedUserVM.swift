//
//  BlockedUserVM.swift
//  PopPool
//
//  Created by Porori on 7/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BlockedUserVM: ViewModelable {
    struct Input {
        let returnTap: ControlEvent<Void>
    }
    
    struct Output {
        let dismissScreen: ControlEvent<Void>
        let userData: Observable<[[String]]>
    }
    
    private let userDataRelay: BehaviorRelay<[[String]]>
    var disposeBag = DisposeBag()
    
    init() {
        let mockData = [
            ["honn", "lasso", "닉네임", "123123"],
            ["이렇게할 수 있을까", "person", "사람입니다", "312312"],
            ["변경", "circle", "이동후", "543225432"],
            ["스티브", "circle", "이후", "231231"]
        ]
        
        userDataRelay = BehaviorRelay(value: mockData)
    }
        // mock data
//        userDataRelay = BehaviorRelay(value: userData)
        
    func transform(input: Input) -> Output {
        
        return Output(
            dismissScreen: input.returnTap,
            userData: userDataRelay.asObservable()
        )
    }
}
