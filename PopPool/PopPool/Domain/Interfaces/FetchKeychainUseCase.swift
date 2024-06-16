//
//  fetchKeychainUseCase.swift
//  PopPool
//
//  Created by Porori on 6/15/24.
//

import Foundation
import RxSwift

protocol FetchKeychainUseCase {
    var keychainRepository: KeyChainRepository { get set }
    
    /// 키체인에 저장된 JWT토큰을 호출합니다
    /// - Parameter key: 사용자의 id을 받습니다
    /// - Returns: 키체인에서 해당 id의 JWT 토큰을 반환합니다
    func fetchJwtToken(key: String) -> Single<String>
}
