//
//  InquiryVM.swift
//  PopPool
//
//  Created by Porori on 8/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class InquiryVM: ViewModelable {
    struct Input {
        var questionTapped: Observable<IndexPath>
    }
    
    struct Output {
        var data: Observable<[String]>
        var openQuestion: Observable<IndexPath>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let test = [
            "추천은 어디서...",
            "저절로 되는건",
            "어떻게 해야할까"
        ]
        let mockData: Observable<[String]> = Observable.just(test)
        
        return Output(
            data:mockData,
            openQuestion: input.questionTapped.asObservable()
        )
    }
}
