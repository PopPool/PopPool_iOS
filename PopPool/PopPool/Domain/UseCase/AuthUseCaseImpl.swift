//
//  AuthUseCaseImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/8/24.
//

import Foundation

import RxSwift

final class AuthUseCaseImpl: AuthUseCase {

    let services: [AuthType: AuthService]
    
    init(services: [AuthType: AuthService]) {
        self.services = services
    }
    
    func fetchUserCredential(from type: AuthType) -> Observable<UserCredential> {
        
        // 주어진 타입에 해당하는 서비스가 있는지 확인
        guard let service = fetchAuthService(type: type) else {
            return Observable.error(AuthError.unknownError)
        }
        
        // 서비스의 사용자 자격 증명을 가져옴
        return service.fetchUserCredential()
    }
}

private extension AuthUseCaseImpl {
    
    /// 주어진 인증 유형에 맞는 AuthService 반환
    /// - Parameter type: AuthService Type
    /// - Returns: 주어진 인증 유형에 맞는 AuthService
    func fetchAuthService(type: AuthType) -> AuthService? {
        return services[type]
    }
}
