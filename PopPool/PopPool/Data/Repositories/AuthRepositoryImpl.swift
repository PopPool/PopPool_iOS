//
//  AuthRepositoryImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/10/24.
//

import Foundation

import RxSwift

final class AuthRepositoryImpl: AuthRepository {
    
    var services: [SocialType: AuthService]
    
    var provider: Provider
    
    init(services: [SocialType : AuthService], provider: Provider) {
        self.services = services
        self.provider = provider
    }
    
    func fetchUserCredential(from type: SocialType) -> Observable<UserCredential> {
        // 주어진 타입에 해당하는 서비스가 있는지 확인
        guard let service = fetchAuthService(type: type) else {
            return Observable.error(AuthError.unknownError)
        }
        
        // 서비스의 사용자 자격 증명을 가져옴
        return service.fetchUserCredential()
    }
    
    func tryLogin(with socialType: SocialType, userCredential: UserCredential) -> Observable<LoginResponseDTO> {
        var endPoint: Endpoint<LoginResponseDTO>
        
        switch socialType {
        case .kakao:
            let request = KakaoLoginRequestDTO(kakaoUserId: userCredential.id, kakaoAccessToken: userCredential.token)
            endPoint = PopPoolAPIEndPoint.tryKakaoLogin(with: request)
        case .apple:
            //추후 수정 필요
            let request = KakaoLoginRequestDTO(kakaoUserId: userCredential.id, kakaoAccessToken: userCredential.token)
            endPoint = PopPoolAPIEndPoint.tryKakaoLogin(with: request)
        }
        
        return provider.requestData(with: endPoint)
    }

}

private extension AuthRepositoryImpl {
    
    /// 주어진 인증 유형에 맞는 AuthService 반환
    /// - Parameter type: AuthService Type
    /// - Returns: 주어진 인증 유형에 맞는 AuthService
    func fetchAuthService(type: SocialType) -> AuthService? {
        return services[type]
    }
}
