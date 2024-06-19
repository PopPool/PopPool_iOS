//
//  AuthRepositoryImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/19/24.
//

import Foundation
import RxSwift

final class AuthRepositoryImpl: AuthRepository {
    
    var provider: Provider
    
    init(provider: Provider) {
        self.provider = provider
    }
    
    func tryLogIn(userCredential: Encodable, socialType: String) -> Observable<LoginResponse> {
        let endPoint = PopPoolAPIEndPoint.tryLogin(with: userCredential, path: socialType)
        return provider
            .requestData(with: endPoint)
            .map { responseDTO in
                return responseDTO.toDomain()
            }
    }
}
