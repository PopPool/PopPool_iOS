//
//  AuthRepository.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/10/24.
//

import Foundation

import RxSwift

protocol AuthRepository {
    
    /// Kakao 소셜 인증 서비스
    var kakaoAuthService: KakaoAuthService { get set }
    /// Apple 소셜 인증 서비스
    var appleAuthService: AppleAuthService { get set }
    /// 데이터를 제공하는 Provider
    var provider: Provider { get set }
    
    /// 사용자 자격 증명을 가져오는 함수
    /// - Returns: KakaoUserCredentialResponseDTO 형태의 사용자 자격 증명
    func fetchUserCredentialFromKakao() -> Observable<KakaoUserCredentialResponse>
    
    /// 사용자 자격 증명을 가져오는 함수
    /// - Returns: AppleUserCredentialResponseDTO 형태의 사용자 자격 증명
    func fetchUserCredentialFromApple() -> Observable<AppleUserCredentialResponse>
    
    /// KakaoUserCredentialResponseDTO와 함께 로그인을 시도합니다.
    /// - Parameter request: KakaoUserCredentialResponseDTO 형태의 사용자 자격 증명
    /// - Returns: LoginResponseDTO 형태의 로그인 응답
    func tryLogin(with request: KakaoUserCredentialResponse) -> Observable<LoginResponseDTO>
}
