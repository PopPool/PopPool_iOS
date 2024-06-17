//
//  AuthUseCaseImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/8/24.
//

import Foundation

import RxSwift

final class FetchUserCredentialUseCaseImpl: FetchUserCredentialUseCase {
    
    func execute<T>(service: T) -> Observable<T.Response> where T : AuthService {
        return service.fetchUserCredential()
    }
}
