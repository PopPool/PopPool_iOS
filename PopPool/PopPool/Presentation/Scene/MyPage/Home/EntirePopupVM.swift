//
//  EntirePopupVM.swift
//  PopPool
//
//  Created by Porori on 8/11/24.
//

import Foundation
import RxSwift
import RxCocoa

class EntirePopupVM: ViewModelable {
    
    struct Input {
        
    }
    
    struct Output {
        let fetchedDataResponse: Observable<GetHomeInfoResponse>
    }
    
    var response: BehaviorRelay<GetHomeInfoResponse> = .init(value: GetHomeInfoResponse())
    
    var disposeBag = DisposeBag()
    func transform(input: Input) -> Output {
        
        return Output(
            fetchedDataResponse: response.asObservable()
        )
    }
}
