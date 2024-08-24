//
//  NoticeBoardVM.swift
//  PopPool
//
//  Created by Porori on 7/29/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NoticeBoardVM: ViewModelable {
    struct Input {
        let returnTapped: ControlEvent<Void>
        let selectedCell: Observable<IndexPath>
        let viewWillAppear: ControlEvent<Void>
    }
    
    struct Output {
        let notices: BehaviorRelay<[NoticeInfo]>
        let popToRoot: ControlEvent<Void>
        let selectedNotice: PublishSubject<(NoticeInfo, NoticeUseCase)>
    }
    
    var disposeBag = DisposeBag()
    
    var noticeUseCase = AppDIContainer.shared.resolve(type: NoticeUseCase.self)
    // MockUpData
    
    var noticeData: BehaviorRelay<[NoticeInfo]> = .init(value: [])
    
    func transform(input: Input) -> Output {
        
        input.viewWillAppear
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.noticeUseCase.fetchNoticeList()
                    .subscribe(onNext: { noticeListResponse in
                        owner.noticeData.accept(noticeListResponse.noticeInfoList)
                    })
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        let noticeOutput: PublishSubject<(NoticeInfo, NoticeUseCase)> = .init()
        
        input.selectedCell
            .withUnretained(self)
            .subscribe { (owner, indexPath) in
                let notice = owner.noticeData.value[indexPath.row]
                noticeOutput.onNext((notice, owner.noticeUseCase))
            }
            .disposed(by: disposeBag)
        return Output(
            notices: noticeData,
            popToRoot: input.returnTapped,
            selectedNotice: noticeOutput
        )
    }
}
