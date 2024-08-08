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
        let title: Observable<String>
        let date: Observable<String>
        let content: Observable<String>
        let popToNoticeBoard: ControlEvent<Void>
    }
    
    var disposeBag = DisposeBag()
    private let notice: [String]
    
    init(data: [String]) {
        self.notice = data
    }
    
    func transform(input: Input) -> Output {
        let title = Observable.just(notice[0])
        let date = Observable.just(notice[1])
        let content = Observable.just(notice[2])
        
        return Output(
            title: title,
            date: date,
            content: content,
            popToNoticeBoard: input.returnTapped)
    }
}
