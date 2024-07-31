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
        let removeUser: Observable<Int>
    }
    
    struct Output {
        let dismissScreen: ControlEvent<Void>
        let userData: BehaviorSubject<[[String]]>
    }
    
    var disposeBag = DisposeBag()
    private let mockData: [[String]] = [
        ["honn", "lasso", "닉네임", "123123"],
        ["이렇게할 수 있을까", "person", "사람입니다", "312312"],
        ["변경", "circle", "이동후", "543225432"],
        ["스티브", "circle", "이후", "231231"]
    ]
        
    func transform(input: Input) -> Output {
        let userDataSubject = BehaviorSubject<[[String]]>(value: [[]])
        userDataSubject.on(.next(mockData))
        
        // 삭제 기능 필요시 연결
        input.removeUser
            .withLatestFrom(userDataSubject) { indexPath, users in
                var updatedUsers = users
                guard indexPath >= 0 && indexPath < updatedUsers.count else { return users }
                updatedUsers.remove(at: indexPath)
                return updatedUsers
            }
            .bind(to: userDataSubject)
            .disposed(by: disposeBag)
        
        return Output(
            dismissScreen: input.returnTap,
            userData: userDataSubject
        )
    }
}
