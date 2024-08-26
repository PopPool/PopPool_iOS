//
//  HomeVM.swift
//  PopPool
//
//  Created by Porori on 8/12/24.
//

import UIKit
import RxSwift

final class HomeVM: ViewModelable {
    struct Input {
        var fetchHome: Observable<Void>
    }
    
    struct Output {
        var homeData: Observable<GetHomeInfoResponse>
    }
    
    var useCase: HomeUseCase
    var disposeBag = DisposeBag()
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {
        
        let fetchedHomeData = input.fetchHome
            .flatMapLatest { _ in
                print(Constants.userId)
                return self.useCase.fetchHome(userId: Constants.userId)
            }
        
        return Output(
            homeData: fetchedHomeData
        )
    }
}
