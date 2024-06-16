//
//  SaveToKeychainUsecase.swift
//  PopPool
//
//  Created by Porori on 6/15/24.
//

import Foundation
import RxSwift

protocol SaveToKeychainUsecase {
    var keychainRepository: KeyChainRepository { get set }
    
    /// 키체인에 JWT토큰을 저장합니다
    /// - Parameters:
    ///   - key: 사용자의 id을 받습니다
    ///   - token: 사용자의 access token 값을 받습니다
    /// - Returns: 반환되는 값은 없습니다
    func saveJwtToken(key: String, token: String) -> Completable
}
