//
//  AuthUseCaseImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/8/24.
//

import Foundation

import RxSwift

final class FetchUserCredentialUseCaseImpl: FetchUserCredentialUseCase {
    
    func execute<R, T>(service: T) -> Observable<R> where R == T.Response, T : AuthService {
        return service.fetchUserCredential()
    }
}
