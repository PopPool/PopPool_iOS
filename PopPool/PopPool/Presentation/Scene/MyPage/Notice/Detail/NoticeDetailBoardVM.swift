//
//  NoticeDetailVM.swift
//  PopPool
//
//  Created by Porori on 7/31/24.
//

import Foundation
import RxSwift
import RxCocoa

class NoticeDetailBoardVM: ViewModelable {
    
    struct Input {
        let returnTapped: ControlEvent<Void>
    }
    
    struct Output {
        let notice: BehaviorRelay<GetNoticeDetailResponse>
        let popToNoticeBoard: ControlEvent<Void>
    }
    
    var disposeBag = DisposeBag()
    
    private let noticeInfo: NoticeInfo
    private let noticeUseCase: NoticeUseCase
    private let noticeData: BehaviorRelay<GetNoticeDetailResponse> = .init(
        value: .init(
            id: 0,
            title: "",
            content: "",
            createDateTime: ""
        )
    )
    
    init(noticeInfo: NoticeInfo, noticeUseCase: NoticeUseCase) {
        self.noticeInfo = noticeInfo
        self.noticeUseCase = noticeUseCase
    }
    
    func transform(input: Input) -> Output {
        
        noticeUseCase.fetchNoticeDetail(noticeId: noticeInfo.id)
            .withUnretained(self)
            .subscribe(onNext: { (owner, response) in
                owner.noticeData.accept(response)
            })
            .disposed(by: disposeBag)
        
        return Output(
            notice: noticeData,
            popToNoticeBoard: input.returnTapped
        )
    }
}
