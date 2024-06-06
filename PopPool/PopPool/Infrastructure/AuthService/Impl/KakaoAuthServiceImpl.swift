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
    var type: AuthType = .kakao
    
    private let disposeBag = DisposeBag()
    
    func tryFetchToken() -> Observable<String> {
        return Observable.create { [weak self] observer in
            
            guard let self = self else {
                observer.onError(AuthError.unknownError)
                return Disposables.create()
            }
            
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.rx.loginWithKakaoAccount()
                    .subscribe { oauthToken in
                        observer.onNext(oauthToken.accessToken)
                        observer.onCompleted()
                    } onError: { error in
                        observer.onError(error)
                    }
                    .disposed(by: self.disposeBag)
            } else {
                observer.onError(AuthError.kakaoTalkNotInstalled)
            }
            return Disposables.create()
        }
    }
    
    func tryFetchUserID() -> Observable<Int> {
        return Observable.create { [weak self] observer in
            
            guard let self = self else {
                observer.onError(AuthError.unknownError)
                return Disposables.create()
            }
            
            UserApi.shared.rx.me()
                .subscribe { user in
                    if let id = user.id {
                        observer.onNext(Int(id))
                        observer.onCompleted()
                    } else {
                        observer.onError(AuthError.emptyData)
                    }
                } onFailure: { error in
                    observer.onError(error)
                }
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
