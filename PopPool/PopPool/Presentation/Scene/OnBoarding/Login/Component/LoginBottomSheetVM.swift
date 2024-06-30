//
//  LoginBottomSheetVM.swift
//  PopPool
//
//  Created by Porori on 6/30/24.
//

import Foundation
import RxSwift
import RxCocoa

class LoginBottomSheetVM: ViewModelable {
    struct Input {
        var loginButtonTapped: ControlEvent<Void>
        var cancelButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let pushToMainScreen: Observable<Void>
        let removeFromScreen: Observable<Void>
    }
    
    private let pushToMainSubject = PublishSubject<Void>()
    private let removeFromScreenSubject = PublishSubject<Void>()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.loginButtonTapped
            .bind(to: pushToMainSubject)
            .disposed(by: disposeBag)
        
        input.cancelButtonTapped
            .bind(to: removeFromScreenSubject)
            .disposed(by: disposeBag)
            
        return Output(
            pushToMainScreen: pushToMainSubject,
            removeFromScreen: removeFromScreenSubject
        )
    }
    
}
