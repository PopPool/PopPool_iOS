//
//  TryLoginUseCase.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/10/24.
//

import Foundation

import RxSwift

protocol TryLoginUseCase {
    
    /// 인증 레포지토리
    var authRepository: AuthRepository { get set }
    
    /// KakaoUserCredentialResponseDTO와 함께 로그인을 시도합니다.
    /// - Parameter request: KakaoUserCredentialResponseDTO 형태의 사용자 자격 증명
    /// - Returns: LoginResponseDTO 형태의 로그인 응답
    func execute(with request: KakaoUserCredentialResponse) -> Observable<LoginResponseDTO>
}

