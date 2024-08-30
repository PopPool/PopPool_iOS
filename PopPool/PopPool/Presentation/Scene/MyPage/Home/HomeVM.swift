//
//  HomeVM.swift
//  PopPool
//
//  Created by Porori on 8/12/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeVM: ViewModelable {
    struct Input {
        
    }
    
    struct Output {
        var myHomeAPIResponse: Observable<GetHomeInfoResponse>
    }
    
    var myHomeAPIResponse: BehaviorRelay<GetHomeInfoResponse> = .init(
        value: .init(
            customPopUpStoreList: [],
            loginYn: true
        ))
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        return Output(
            myHomeAPIResponse: myHomeAPIResponse.asObservable()
        )
    }
}
