//
//  RecentPopUpVM.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/25/24.
//

import Foundation

import RxSwift
import RxCocoa

final class RecentPopUpVM: ViewModelable {
    
    struct Input {
        var backButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        var popUpList: BehaviorRelay<GetMyRecentViewPopUpStoreListResponse>
        var moveToRecentVC: ControlEvent<Void>
    }
    
    var popUpList: BehaviorRelay<GetMyRecentViewPopUpStoreListResponse> = .init(
        value: .init(popUpInfoList: [], totalPages: 0, totalElements: 0)
    )
    var disposeBag = DisposeBag()
    
    private let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    func transform(input: Input) -> Output {
        userUseCase.fetchMyRecentViewPopUpStoreList(
            userId: Constants.userId,
            page: 0,
            size: 10,
            sort: nil
        )
        .withUnretained(self)
        .subscribe { (owner, response) in
            owner.popUpList.accept(response)
        }
        .disposed(by: disposeBag)
        
        return Output(
            popUpList: popUpList,
            moveToRecentVC: input.backButtonTapped
        )
    }
}
