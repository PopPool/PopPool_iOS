//
//  SignOutCompleteVM.swift
//  PopPool
//
//  Created by Porori on 9/4/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignOutCompleteVM: ViewModelable {
    struct Input {
        let deleteUserTapped: ControlEvent<Void>
    }
    
    struct Output {
        let returnToRoot: Observable<Void>
    }
    
    var disposeBag = DisposeBag()
    private let useCase: UserUseCase
    private let survey: [Survey]
    
    init(survey: [Survey]) {
        self.survey = survey
        self.useCase = AppDIContainer.shared.resolve(type: UserUseCase.self)
    }
    
    func transform(input: Input) -> Output {
        
        let returnToRoot = input.deleteUserTapped
            .withUnretained(self)
            .do(onNext: { (owner, _) in
                owner.useCase.tryWithdraw(userId: Constants.userId, surveyList: owner.survey)
                    .subscribe(onCompleted: {
                        print("탈퇴가 완료되었습니다.")
                    })
                    .disposed(by: owner.disposeBag)
            })
            .map { _ in () }
            
        return Output(
            returnToRoot: returnToRoot
        )
    }
}
