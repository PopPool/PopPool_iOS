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
        let userData: BehaviorRelay<[BlockedUserInfo]>
    }
    
    var disposeBag = DisposeBag()
    var userUseCase: UserUseCase
    var blokedUser: PublishSubject<BlockedUserInfo> = .init()
    var unblockedUser: PublishSubject<BlockedUserInfo> = .init()
    init(useUseCase: UserUseCase) {
        self.userUseCase = useUseCase
    }
    
    let blockedUserList: BehaviorRelay<[BlockedUserInfo]> = .init(value: [])
        
    func transform(input: Input) -> Output {
        
        blokedUser
            .withUnretained(self)
            .subscribe { (owner, target) in
                owner.userUseCase.userBlock(blockerUserId: Constants.userId, blockedUserId: target.userId)
                    .subscribe {
                        ToastMSGManager.createToast(message: "\(target.nickname)님을 차단했습니다.")
                    } onError: { _ in
                        print("Blocked Fail")
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        unblockedUser
            .withUnretained(self)
            .subscribe { (owner, target) in
                owner.userUseCase.userUnblock(blockerUserId: Constants.userId, blockedUserId: target.userId)
                    .subscribe {
                        ToastMSGManager.createToast(message: "차단을 해제했어요")
                    } onError: { _ in
                        print("Unblocked Fail")
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        userUseCase.fetchBlockedUserList(userId: Constants.userId, page: 0, size: 10, sort: nil)
            .withUnretained(self)
            .subscribe { (owner, response) in
                owner.blockedUserList.accept(response.blockedUserInfoList)
            }
            .disposed(by: disposeBag)
        
//        // 삭제 기능 필요시 연결
//        input.removeUser
//            .withLatestFrom(userDataSubject) { indexPath, users in
//                var updatedUsers = users
//                guard indexPath >= 0 && indexPath < updatedUsers.count else { return users }
//                updatedUsers.remove(at: indexPath)
//                return updatedUsers
//            }
//            .bind(to: userDataSubject)
//            .disposed(by: disposeBag)
        
        return Output(
            dismissScreen: input.returnTap,
            userData: blockedUserList
        )
    }
}
