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
        let returnActionTapped: ControlEvent<Void>
        let skipActionTapped: ControlEvent<Void>
        let confirmActionTapped: ControlEvent<Void>
    }
    
    struct Output {
        let surveylist: Observable<[Survey]>
        let skipScreen: ControlEvent<Void>
        let moveToNextScreen: ControlEvent<Void>
        let returnToRoot: ControlEvent<Void>
    }
    
    private let useCase: UserUseCase
    private var fetchedSurvey = PublishSubject<[Survey]>()
    var survey: [Survey] = []
    var selectedArray: [Survey] = []
    
    init() {
        self.useCase = AppDIContainer.shared.resolve(type: UserUseCase.self)
    }
    
    func transform(input: Input) -> Output {
        
        // 서베이 데이터를 API를 통해 호출해 옵니다
        useCase.fetchWithdrawlSurveryList()
            .map { response in
                return response.withDrawlSurveyList.map { $0 }
            }
            .withUnretained(self)
            .subscribe(onNext: { (owner, response) in
                owner.survey = response // viewModel의 데이터
                owner.fetchedSurvey.onNext(response) // vc이 따를 수 있는 이벤트
            })
            .disposed(by: disposeBag)
                
        return Output(
            surveylist: fetchedSurvey.asObservable(),
            skipScreen: input.skipActionTapped,
            moveToNextScreen: input.confirmActionTapped,
            returnToRoot: input.returnActionTapped
        )
    }
}
