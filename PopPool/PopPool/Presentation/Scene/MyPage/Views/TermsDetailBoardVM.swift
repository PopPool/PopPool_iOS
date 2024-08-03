//
//  TermsDetailBoardVM.swift
//  PopPool
//
//  Created by Porori on 8/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class TermsDetailBoardVM: ViewModelable {
    struct Input {
        let dismissTapped: ControlEvent<Void>
        let data: Observable<[String]>
    }
    
    struct Output {
        let title: Observable<String>
        let content: Observable<String>
        let dismissFromScreen: ControlEvent<Void>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
    }
    
    func transform(input: Input) -> Output {
        
        // TermsData DTO 생성 이후 변경 필요
        let title = input.data.map { $0[0] }
        let content = input.data.map { $0[1] }
        
        return Output(
            title: title,
            content: content,
            dismissFromScreen: input.dismissTapped
        )
    }
}
