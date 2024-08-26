//
//  MyCommentedPopUpVM.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/11/24.
//

import Foundation

import RxSwift
import RxCocoa

final class MyCommentedPopUpVM: ViewModelable {
    
    
    
    struct Input {
        var filterButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        var instaCommentList: BehaviorRelay<GetMyCommentResponse>
        var normalCommentList: BehaviorRelay<GetMyCommentResponse>
        var moveToBottomModalVC: PublishSubject<Void>
    }
    
    
    
    // MARK: - Properties
    
    private let size: Int32 = 10
    
    let segmentSelectedIndex: BehaviorRelay<Int> = .init(value: 0)
    
    var normalCommentList: BehaviorRelay<GetMyCommentResponse> = .init(
        value: .init(
            myCommentList: [],
            totalPages: 0,
            totalElements: 0
        )
    )
    
    var instaCommentList: BehaviorRelay<GetMyCommentResponse> = .init(
        value: .init(
            myCommentList: [],
            totalPages: 0,
            totalElements: 0
        )
    )
    
    private var userUseCase: UserUseCase
    
    var disposeBag = DisposeBag()
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    func transform(input: Input) -> Output {
        
        segmentSelectedIndex
            .withUnretained(self)
            .subscribe { (owner, selectIndex) in
                
                let sort = selectIndex == 0 ? nil : ["commentCount,desc"]
                
                owner.userUseCase.fetchMyComment(
                    userId: Constants.userId,
                    page: 0,
                    size: owner.size,
                    sort: sort,
                    commentType: .normal
                )
                .subscribe { response in
                    owner.normalCommentList.accept(response)
                }
                .disposed(by: owner.disposeBag)
                
                owner.userUseCase.fetchMyComment(
                    userId: Constants.userId,
                    page: 0,
                    size: owner.size,
                    sort: sort,
                    commentType: .instagram
                )
                .subscribe { response in
                    owner.instaCommentList.accept(response)
                }
                .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)

        
        let moveToBottomModalVC: PublishSubject<Void> = .init()
        input.filterButtonTapped
            .subscribe { _ in
                moveToBottomModalVC.onNext(())
            }
            .disposed(by: disposeBag)
        
        return Output(
            instaCommentList: instaCommentList,
            normalCommentList: normalCommentList,
            moveToBottomModalVC: moveToBottomModalVC
        )
    }
}
