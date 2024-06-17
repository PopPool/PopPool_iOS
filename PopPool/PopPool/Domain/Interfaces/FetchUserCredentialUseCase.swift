//
//  AuthUseCase.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/8/24.
//

import Foundation

import RxSwift

protocol FetchUserCredentialUseCase {
    
    /// 사용자의 자격 증명을 가져오는 메서드입니다.
    /// - Parameter service: 인증 서비스 객체
    /// - Returns: 인증 서비스에서 반환하는 응답을 포함하는 Observable 객체
    func execute<R, T: AuthService>(service: T) -> Observable<R> where R == T.Response
}
