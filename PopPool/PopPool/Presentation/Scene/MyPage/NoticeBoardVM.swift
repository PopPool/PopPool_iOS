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
        let selectedNotice: Observable<IndexPath>
    }
    
    struct Output {
        let notices: Observable<[String]>
    }
    
    private let noticeRelay = BehaviorRelay<[String]>(value: [])
    var disposeBag = DisposeBag()
    
    init() {
        // mockData
        let mockData = ["제목", "작성자", "콘텐츠 주저리주저리"]
        noticeRelay.accept(mockData)
    }

    func transform(input: Input) -> Output {
        
        return Output(
            notices: noticeRelay.asObservable()
        )
    }
}
