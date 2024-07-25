//
//  BlockedUserVM.swift
//  PopPool
//
//  Created by Porori on 7/24/24.
//

import UIKit
import RxSwift
import RxCocoa

final class BlockedUserVM: ViewModelable {
    struct Input {
        let returnTap: ControlEvent<Void>
    }
    
    struct Output {
        let returnTapped: ControlEvent<Void>
        let userData: Observable<[UserBlocked]>
    }
    
    var userData: BlockedUserResponse
    var disposeBag = DisposeBag()
    
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
    }
    
    // getData를 통해 Observable을 리턴. of로 전달하여 이벤트 생성
    private func getData() -> Observable<[UserBlocked]>{
        return Observable.of(userData.blockedUserInfoList)
    }
    
    func transform(input: Input) -> Output {
        let userDataObservable = getData()
        return Output(
            returnTapped: input.returnTap,
            userData: userDataObservable
        )
    }
}
