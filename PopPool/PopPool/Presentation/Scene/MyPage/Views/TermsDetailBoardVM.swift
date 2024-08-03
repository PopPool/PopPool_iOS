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
    }
    
    struct Output {
//        let title: Observable<String>
//        let content: Observable<String>
        let dismissFromScreen: ControlEvent<Void>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output(
//            title: <#T##Observable<String>#>,
//            content: <#T##Observable<String>#>,
            dismissFromScreen: input.dismissTapped
        )
    }
}
