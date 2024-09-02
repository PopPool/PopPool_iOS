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
        var moveToBottomModalVC: PublishSubject<Void>
        var sortedButtonResponse: BehaviorRelay<Int>
        var normalCommentList: BehaviorRelay<GetMyCommentResponse>
        var instaCommentList: BehaviorRelay<GetMyCommentResponse>
    }
    
    
    
    // MARK: - Properties
    
    private let size: Int32 = 20
    
    let segmentSelectedIndex: BehaviorRelay<Int> = .init(value: 0)
    
    var normalCommentList: BehaviorRelay<GetMyCommentResponse> = .init(
        value: .init(
            myCommentList: [],
            totalPages: 0,
            totalElements: 0
        )
    )
    var normalPage: BehaviorRelay<Int32> = .init(value: 0)
    var normalIsLoading: Bool = false
    
    var instaCommentList: BehaviorRelay<GetMyCommentResponse> = .init(
        value: .init(
            myCommentList: [],
            totalPages: 0,
            totalElements: 0
        )
    )
    var instaPage: BehaviorRelay<Int32> = .init(value: 0)
    var instaIsLoading: Bool = false
    
    var sort: [String]? = nil
    
    private var userUseCase: UserUseCase
    
    var disposeBag = DisposeBag()
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    func transform(input: Input) -> Output {
        
        
        normalPage
            .withUnretained(self)
            .subscribe { (owner, page) in
                if !owner.normalIsLoading {
                    owner.normalIsLoading = true
                    owner.userUseCase.fetchMyComment(
                        userId: Constants.userId,
                        page: page,
                        size: owner.size,
                        sort: owner.sort,
                        commentType: .normal
                    )
                    .subscribe(onNext: { response in
                        let oldData = owner.normalCommentList.value.myCommentList
                        var data = response
                        data.myCommentList = oldData + data.myCommentList
                        owner.normalCommentList.accept(data)
                        owner.normalIsLoading = false
                    })
                    .disposed(by: owner.disposeBag)
                }
            }.disposed(by: disposeBag)
        
        instaPage
            .withUnretained(self)
            .subscribe { (owner, page) in
                if !owner.instaIsLoading {
                    owner.instaIsLoading = true
                    owner.userUseCase.fetchMyComment(
                        userId: Constants.userId,
                        page: page,
                        size: owner.size,
                        sort: owner.sort,
                        commentType: .instagram
                    )
                    .subscribe { response in
                        let oldData = owner.instaCommentList.value.myCommentList
                        var data = response
                        data.myCommentList = oldData + data.myCommentList
                        owner.instaCommentList.accept(data)
                        owner.instaIsLoading = false
                    }
                    .disposed(by: owner.disposeBag)
                }
            }.disposed(by: disposeBag)
        
        segmentSelectedIndex
            .withUnretained(self)
            .subscribe { (owner, selectIndex) in
                let sort = selectIndex == 0 ? nil : ["likeCount","desc"]
                owner.sort = sort
                owner.instaCommentList.accept(.init(myCommentList: [], totalPages: 0, totalElements: 0))
                owner.normalCommentList.accept(.init(myCommentList: [], totalPages: 0, totalElements: 0))
                owner.normalPage.accept(0)
                owner.instaPage.accept(0)
            }
            .disposed(by: disposeBag)
        let moveToBottomModalVC: PublishSubject<Void> = .init()
        input.filterButtonTapped
            .subscribe { _ in
                moveToBottomModalVC.onNext(())
            }
            .disposed(by: disposeBag)
        
        return Output(
            moveToBottomModalVC: moveToBottomModalVC,
            sortedButtonResponse: segmentSelectedIndex,
            normalCommentList: normalCommentList,
            instaCommentList: instaCommentList
        )
    }
}
