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
        let returnTapped: ControlEvent<Void>
        let userData: BehaviorRelay<[UserBlocked]>
    }
    
    private var userData: BlockedUserResponse
    var disposeBag = DisposeBag()
    var userDataRelay = BehaviorRelay<[UserBlocked]>(value: [])
    
    init() {
        // mock data
        userData = BlockedUserResponse(
            blockedUserInfoList: [
                UserBlocked(
                    userId: "honn",
                    profileImage: "lasso",
                    nickname: "닉네임",
                    instagramId: "123123"),
                UserBlocked(
                    userId: "이렇게할 수 있을까",
                    profileImage: "person",
                    nickname: "사람입니다",
                    instagramId: "312312"),
                UserBlocked(
                    userId: "스티브",
                    profileImage: "circle",
                    nickname: "이동후",
                    instagramId: "543225432"),
                UserBlocked(
                    userId: "변경",
                    profileImage: "이래도?",
                    nickname: "이후",
                    instagramId: "231231")
            ],
            totalPages: 1,
            totalElements: 3)
        
        userDataRelay = BehaviorRelay(value: userData.blockedUserInfoList)
    }
        
    func transform(input: Input) -> Output {
        
        input.removeUser
            .withLatestFrom(userDataRelay) { indexPath, users in
                var updatedUsers = users
                guard indexPath >= 0 && indexPath < updatedUsers.count else { return users }
                updatedUsers.remove(at: indexPath)
                return updatedUsers
            }
            .bind(to: userDataRelay)
            .disposed(by: disposeBag)
        
        return Output(
            returnTapped: input.returnTap,
            userData: userDataRelay
        )
    }
}
