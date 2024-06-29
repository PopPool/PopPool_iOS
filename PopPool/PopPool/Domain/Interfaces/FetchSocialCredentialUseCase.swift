//
//  FetchSocialCredentialUseCase.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/8/24.
//

import Foundation

import RxSwift

protocol FetchSocialCredentialUseCase {
    
    var service: any AuthService { get set }
    
    /// 사용자의 자격 증명을 가져오는 메서드입니다.
    /// - Returns: 인증 서비스에서 반환하는 응답을 포함하는 Observable 객체
    func execute() -> Observable<Encodable>
}
