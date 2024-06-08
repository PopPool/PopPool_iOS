//
//  AuthService.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/5/24.
//

import Foundation
import RxSwift

protocol AuthService {
    /// SDK로부터 사용자 인증 데이터를 가져오려고 시도합니다.
    /// - Returns: UserCredential로 방출하거나 오류를 방출하는 Observable.
    func fetchUserCredential() -> Observable<UserCredential>
}
