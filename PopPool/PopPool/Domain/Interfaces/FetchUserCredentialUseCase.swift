//
//  AuthUseCase.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/8/24.
//

import Foundation

import RxSwift

protocol FetchUserCredentialUseCase {
    
    /// 사용자 자격 증명을 가져오는 함수
    /// - Parameter type: 인증 유형 (카카오 또는 애플)
    /// - Returns: Observable<UserCredential> 형태의 사용자 자격 증명
    func start(from type: AuthType) -> Observable<UserCredential>
}



