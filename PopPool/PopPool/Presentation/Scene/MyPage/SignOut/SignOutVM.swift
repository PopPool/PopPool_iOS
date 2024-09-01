//
//  SignOutVM.swift
//  PopPool
//
//  Created by Porori on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignOutVM: ViewModelable {
    var disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        var surveylist: Observable<[String]>
    }
    
    private let useCase: UserUseCase
    
    init() {
        self.useCase = AppDIContainer.shared.resolve(type: UserUseCase.self)
    }
    
    func transform(input: Input) -> Output {
        let fetchedSurvey = PublishSubject<[String]>()
        
        useCase.fetchWithdrawlSurveryList()
            .map { response in
                return response.withDrawlSurveyList.map { $0.survey }
            }
            .subscribe(onNext: { surveyName in
                fetchedSurvey.onNext(surveyName)
            })
            .disposed(by: disposeBag)
        
        return Output(
            surveylist: fetchedSurvey.asObservable()
        )
    }
}
