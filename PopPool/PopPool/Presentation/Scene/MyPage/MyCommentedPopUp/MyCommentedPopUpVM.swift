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
    
    var disposeBag = DisposeBag()
    
    struct Input {
        var filterButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        var moveToBottomModalVC: PublishSubject<Void>
    }
    
    func transform(input: Input) -> Output {
        let moveToBottomModalVC: PublishSubject<Void> = .init()
        input.filterButtonTapped
            .subscribe { _ in
                moveToBottomModalVC.onNext(())
            }
            .disposed(by: disposeBag)
        return Output(
            moveToBottomModalVC: moveToBottomModalVC
        )
    }
}
