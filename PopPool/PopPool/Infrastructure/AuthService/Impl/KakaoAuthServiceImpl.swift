//
//  KakaoAuthServiceImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/5/24.
//

import Foundation

import KakaoSDKUser
import RxSwift

class KakaoAuthServiceImpl: AuthService {
    
    private let disposeBag = DisposeBag()
    
    func tryFetchToken() -> Observable<String> {
        
        return Observable.create { observer in
            
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
}
