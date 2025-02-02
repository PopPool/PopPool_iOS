//
//  KakaoAuthServiceImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/5/24.
//

import Foundation

import KakaoSDKUser
import RxSwift

final class KakaoAuthServiceImpl: AuthService {
    
    struct Credential: Encodable {
        var kakaoUserId: Int64
        var kakaoAccessToken: String
    }
    
    private let disposeBag = DisposeBag()
    
    private var userEmail: String = ""
    
    func fetchUserCredential() -> Observable<AuthServiceResponse> {
        
        return fetchToken()
            .withUnretained(self)
            .flatMap { (owner, token) in
                owner.fetchUserID()
                    .map { id in
                        let credential: Credential = Credential(kakaoUserId: id, kakaoAccessToken: token)
                        return AuthServiceResponse(credential: credential, socialType: "KAKAO", userEmail: owner.userEmail)
                    }
            }.catch { error in
                Observable.error(error)
            }
    }
}

private extension KakaoAuthServiceImpl {
    
    func fetchToken() -> Observable<String> {
        return Observable.create { [weak self] observer in
            
            // self 참조가 유효한지 확인
            guard let self = self else {
                observer.onError(AuthError.unknownError)
                return Disposables.create()
            }
            
            // 카카오톡을 통해 로그인이 가능한지 확인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.rx.loginWithKakaoAccount()
                    .subscribe { oauthToken in
                        // 액세스 토큰을 방출하고 observable을 완료함
                        observer.onNext(oauthToken.accessToken)
                        observer.onCompleted()
                    } onError: { error in
                        // 로그인 과정에서 오류 발생 시 오류를 방출
                        observer.onError(error)
                    }
                    .disposed(by: self.disposeBag)
            } else {
                // 카카오톡이 설치되지 않은 경우 오류를 방출
                observer.onError(AuthError.notInstalled)
            }
            return Disposables.create()
        }
    }
    
    func fetchUserID() -> Observable<Int64> {
        
        return Observable.create { [weak self] observer in
            
            // self 참조가 유효한지 확인
            guard let self = self else {
                observer.onError(AuthError.unknownError)
                return Disposables.create()
            }
            
            UserApi.shared.rx.me()
                .subscribe { user in
                    if let id = user.id {
                        if let email = user.kakaoAccount?.email {
                            self.userEmail = email
                            // 사용자 ID를 방출하고 observable을 완료함
                            observer.onNext(id)
                            observer.onCompleted()
                        }
                    } else {
                        // 사용자 ID가 nil인 경우 오류를 방출
                        observer.onError(AuthError.emptyData)
                    }
                } onFailure: { error in
                    // 요청 실패 시 오류를 방출
                    observer.onError(error)
                }
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
