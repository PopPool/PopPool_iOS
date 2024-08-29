//
//  FavoritePopUpVM.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/27/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class FavoritePopUpVM: ViewModelable {

    enum ViewType: Int {
        case cardList = 0
        case grid = 1
        
        var title: String {
            switch self {
            case .cardList:
                "크게 보기"
            case .grid:
                "모아서 보기"
            }
        }
        
        var layout: UICollectionViewFlowLayout {
            switch self {
            case .cardList:
                return CardListLayout()
            case .grid:
                return GridLayout(height: 255)
            }
        }
    }
    // MARK: - Input
    struct Input {
        var didTapFilterButton: ControlEvent<Void>
        var reloadTrigger: PublishSubject<Int64>
    }
    
    // MARK: - Output
    struct Output {
        var moveToFilterModalVC: ControlEvent<Void>
        var viewType: BehaviorRelay<ViewType>
        var popUpList: BehaviorRelay<GetBookMarkPopUpStoreListResponse>
    }
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    var userUseCase: UserUseCase
    var viewType: BehaviorRelay<ViewType> = .init(value: .cardList)
    var popUpList: BehaviorRelay<GetBookMarkPopUpStoreListResponse> = .init(value: GetBookMarkPopUpStoreListResponse(popUpInfoList: [], totalPages: 0, totalElements: 0))
    
    // MARK: - init
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    func transform(input: Input) -> Output {
        
        input.reloadTrigger
            .withUnretained(self)
            .subscribe { (owner, deleteId) in
                owner.userUseCase.deleteBookMarkPopUpStore(userId: Constants.userId, popUpStoreId: deleteId)
                    .subscribe {
                        ToastMSGManager.createToast(message: "북마크 해제 완료")
                    } onError: { _ in
                        ToastMSGManager.createToast(message: "네트워크 오류")
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        userUseCase.fetchBookMarkPopUpStoreList(userId: Constants.userId, page: 0, size: 10, sort: nil)
            .withUnretained(self)
            .subscribe { (owner, response) in
                owner.popUpList.accept(response)
            }
            .disposed(by: disposeBag)
        return Output(
            moveToFilterModalVC: input.didTapFilterButton,
            viewType: viewType,
            popUpList: popUpList
        )
    }
}
