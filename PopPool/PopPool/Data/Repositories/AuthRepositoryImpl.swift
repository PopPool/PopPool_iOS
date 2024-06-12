//
//  AuthRepositoryImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/10/24.
//

import Foundation

import RxSwift

final class AuthRepositoryImpl {
    
    var kakaoAuthService: KakaoAuthService
    var appleAuthService: AppleAuthService
    
    var provider: Provider
    
    init(kakaoAuthService: KakaoAuthService, appleAuthService: AppleAuthService, provider: Provider) {
        self.kakaoAuthService = kakaoAuthService
        self.appleAuthService = appleAuthService
        self.provider = provider
    }
    
    func fetchUserCredentialFromKakao() -> Observable<KakaoUserCredentialResponse> {
        return kakaoAuthService.fetchUserCredential()
    }
    
    func fetchUserCredentialFromApple() -> Observable<AppleUserCredentialResponse> {
        return appleAuthService.fetchUserCredential()
    }
    
    func tryLogin(with request: KakaoUserCredentialResponse) -> Observable<LoginResponseDTO> {
        
        let request = KakaoLoginRequestDTO(kakaoUserId: request.id, kakaoAccessToken: request.token)
        let endpoint = PopPoolAPIEndPoint.tryKakaoLogin(with: request)
        return provider.requestData(with: endpoint)
    }

}
