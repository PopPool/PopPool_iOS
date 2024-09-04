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
                print(owner.survey)
                owner.useCase.tryWithdraw(
                    userId: Constants.userId,
                    surveyList: .init(checkedSurveyList: owner.survey.map{ .init(id: $0.id, survey: $0.survey)})
                )
                .subscribe(onCompleted: {
                    let service = KeyChainServiceImpl()
                    service.saveToken(type: .accessToken, value: "SignOut")
                        .subscribe(onCompleted: {
                            print("SignOut Complete AccessToken Remove")
                        },onError: { _ in
                            print("SignOut Complete AccessToken Remove Fail")
                        })
                        .disposed(by: owner.disposeBag)
                    
                    service.saveToken(type: .refreshToken, value: "SignOut")
                        .subscribe(onCompleted: {
                            print("SignOut Complete RefreshToken Remove")
                        },onError: { _ in
                            print("SignOut Complete RefreshToken Remove Fail")
                        })
                        .disposed(by: owner.disposeBag)
                    print("탈퇴가 완료되었습니다.")
                },onError: { error in
                    print(error.localizedDescription)
                })
                .disposed(by: owner.disposeBag)
            })
            .map { _ in () }
        
        return Output(
            returnToRoot: returnToRoot
        )
    }
}
