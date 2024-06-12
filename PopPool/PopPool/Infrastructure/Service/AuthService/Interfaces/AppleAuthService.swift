//
//  AppleAuthService.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/12/24.
//

import Foundation

import RxSwift

protocol AppleAuthService {
    
    /// 사용자 자격 증명을 가져오는 함수
    /// - Returns: AppleUserCredentialResponseDTO 형태의 사용자 자격 증명
    func fetchUserCredential() -> Observable<AppleUserCredentialResponse>
}
