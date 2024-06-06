//
//  AuthService.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/5/24.
//

import Foundation
import RxSwift

protocol AuthService {
    var type: AuthType { get set }
    
    /// Kakao로부터 OAuth 토큰을 가져오려고 시도합니다.
    /// - Returns: 액세스 토큰 문자열 또는 오류를 방출하는 Observable.
    func fetchToken() -> Observable<String>
    
    /// Kakao로부터 사용자 ID를 가져오려고 시도합니다.
    /// - Returns: 사용자 ID를 정수로 방출하거나 오류를 방출하는 Observable.
    func fetchUserID() -> Observable<Int>
}

enum AuthType {
    case kakao
    case apple
}
