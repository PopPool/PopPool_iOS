//
//  AuthRepository.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/10/24.
//

import Foundation

import RxSwift

protocol AuthRepository {
    
    /// 소셜 인증 서비스를 담고 있는 딕셔너리
    var services: [SocialType: AuthService] { get set }
    
    /// 데이터를 제공하는 Provider
    var provider: Provider { get set }
    
    /// 사용자 자격 증명을 가져오는 함수
    /// - Parameter type: 소셜 유형
    /// - Returns: Observable<UserCredential> 형태의 사용자 자격 증명
    func fetchUserCredential(from type: SocialType) -> Observable<UserCredential>
    
    /// 사용자 자격 증명을 사용하여 로그인 시도
    /// - Parameters:
    ///   - socialType: 소셜 유형
    ///   - userCredential: 사용자 자격 증명
    /// - Returns: Observable<LoginResponseDTO> 형태의 로그인 응답
    func tryLogin(with socialType: SocialType, userCredential: UserCredential) -> Observable<LoginResponseDTO>
}
