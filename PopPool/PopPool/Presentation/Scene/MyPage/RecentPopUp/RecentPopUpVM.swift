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
    
    var page: BehaviorRelay<Int32> = .init(value: 0)
    var isLoading: Bool = false
    var disposeBag = DisposeBag()
    
    private let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    func transform(input: Input) -> Output {
        page
            .withUnretained(self)
            .subscribe { (owner, page) in
                owner.isLoading = true
                owner.userUseCase.fetchMyRecentViewPopUpStoreList(
                    userId: Constants.userId,
                    page: page,
                    size: 20,
                    sort: nil
                )
                .subscribe { response in
                    let oldData = owner.popUpList.value.popUpInfoList
                    var data = response
                    data.popUpInfoList = oldData + data.popUpInfoList
                    owner.popUpList.accept(data)
                    owner.isLoading = false
                }
                .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        return Output(
            popUpList: popUpList,
            moveToRecentVC: input.backButtonTapped
        )
    }
}
