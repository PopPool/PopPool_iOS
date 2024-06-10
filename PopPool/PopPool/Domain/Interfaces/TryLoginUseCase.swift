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
    
    /// 주어진 소셜 유형과 사용자 자격 증명을 사용하여 로그인 시도
    /// - Parameters:
    ///   - type: 소셜 유형 (예: Kakao, Google 등)
    ///   - userCredential: 사용자 자격 증명 정보
    /// - Returns: Observable<LoginResponseDTO> 형태의 로그인 응답
    func execute(with type: SocialType, userCredential: UserCredential) -> Observable<LoginResponseDTO>
}

