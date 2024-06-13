//
//  TryLoginUseCaseImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/10/24.
//

import Foundation

import RxSwift

final class TryLoginUseCaseImpl: TryLoginUseCase {
    
    var authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(with request: KakaoUserCredentialResponse) -> Observable<LoginResponseDTO> {
        return authRepository.tryLogin(with: request)
    }
}
