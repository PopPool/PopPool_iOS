//
//  AuthUseCase.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/8/24.
//

import Foundation

import RxSwift

protocol FetchUserCredentialUseCase {
    
    /// 인증 레포지토리
    var authRepository: AuthRepository { get set }
    
    /// 사용자 자격 증명을 가져오는 함수
    /// - Parameter type: 소셜 유형
    /// - Returns: Observable<UserCredential> 형태의 사용자 자격 증명
    func start(from type: SocialType) -> Observable<UserCredential>
}



