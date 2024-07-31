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
    }
    
    struct Output {
        let notices: Observable<[[String]]>
        let popToRoot: ControlEvent<Void>
    }
    
    var disposeBag = DisposeBag()
    
    // MockUpData
    let mockData: [[String]] = [
        ["테스트 제목1", "작성자", "콘텐츠"],
        ["테스트 제목2", "작성자2", "콘텐츠"],
        ["테스트 제목3", "작성자3", "콘텐츠"],
        ["테스트 제목4", "작성자4", "콘텐츠"],
    ]
    
    func transform(input: Input) -> Output {
        let noticeOutput = Observable.just(mockData)
        
        return Output(
            notices: noticeOutput,
            popToRoot: input.returnTapped
        )
    }
}
