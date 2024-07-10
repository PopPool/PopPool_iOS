//
//  LoginVM.swift
//  PopPool
//
//  Created by Porori on 6/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginVM: ViewModelable {

    /// LoginVC의 입력 이벤트
    struct Input {
        /// 뒤로 돌아가기 버튼 탭
        var tourButtonTapped: ControlEvent<Void>
        /// 카카오 로그인 버튼 탭
        var kakaoLoginButtonTapped: ControlEvent<Void>
        /// 애플 로그인 버튼 탭
        var appleLoginButtonTapped: ControlEvent<Void>
        /// 문의 버튼 탭
        var inquryButtonTapped: ControlEvent<Void>
    }
    
    /// LoginVC으로 출력 이벤트
    struct Output {
        let moveToInquryVC: ControlEvent<Void>
        let moveToSignUpVC: PublishSubject<String>
    }
    
    private var fetchSocialUserCredencialUseCase: FetchSocialCredentialUseCase!
    private let tryLoginUseCase: TryLoginUseCase
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        self.tryLoginUseCase = AppDIContainer.shared.resolve(type: TryLoginUseCase.self)
    }
    
    /// LoginVC로 부터 받은 Input을 Output으로 변환하는 메서드
    /// - Parameter input: LoginVC에서 발생한 입력에 대한 이벤트 구조체
    /// - Returns: LoginVC에 발생할 출력 구조체
    func transform(input: Input) -> Output {
        let fetchSocialUserCredencialSubject: PublishSubject<String> = .init()
        let tryLoginSubject: PublishSubject<(Encodable, String)> = .init()
        let moveToSignUpVCSubject: PublishSubject<String> = .init()
        let moveToHomeVCSubject: PublishSubject<LoginResponse> = .init()
        
        // 카카오 로그인 버튼 입력
        input.kakaoLoginButtonTapped
            .map{ Constants.socialType.kakao }
            .subscribe { socialType in
                fetchSocialUserCredencialSubject.onNext(socialType)
            }
            .disposed(by: disposeBag)
        
        // 애플 로그인 버튼 입력
        input.appleLoginButtonTapped
            .map{ Constants.socialType.apple }
            .subscribe { socialType in
                fetchSocialUserCredencialSubject.onNext(socialType)
            }
            .disposed(by: disposeBag)
        
        // 소셜 로그인 이벤트 처리
        fetchSocialUserCredencialSubject
            .withUnretained(self)
            .subscribe { (owner, socialType) in
                // 이벤트 버튼에 따라 useCase 생성
                owner.fetchSocialUserCredencialUseCase = AppDIContainer.shared.resolve(
                    type: FetchSocialCredentialUseCase.self,
                    identifier: socialType
                )
                // 소셜 인증 유즈 케이스 실행
                owner.fetchSocialUserCredencialUseCase
                    .execute()
                    .subscribe(onNext: { response in
                        tryLoginSubject.onNext((response, socialType))
                    },onError: { error in
                        // 소셜 인증 error handle
                        ToastMSGManager.createToast(message: "SocialLogin Error")
                        print(error.localizedDescription)
                    })
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        // 로그인 시도 이벤트
        tryLoginSubject
            .withUnretained(self)
            .subscribe { (owner, source) in
                let credencial = source.0
                let type = source.1
                owner.tryLoginUseCase
                    .execute(userCredential: credencial, socialType: type)
                    .subscribe { loginResponse in
                        // 등록된 유저인지를 분기하여 이벤트 전달
                        if loginResponse.registeredUser {
                            moveToHomeVCSubject.onNext(loginResponse)
                        } else {
                            moveToSignUpVCSubject.onNext(loginResponse.socialType)
                        }
                    } onError: { error in
                        // 로그인 error handle
                        ToastMSGManager.createToast(message: "LoginError")
                        print(error.localizedDescription)
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)

        return Output(
            moveToInquryVC: input.inquryButtonTapped,
            moveToSignUpVC: moveToSignUpVCSubject
        )
    }
}
