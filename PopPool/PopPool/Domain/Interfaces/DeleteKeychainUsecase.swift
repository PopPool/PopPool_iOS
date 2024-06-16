//
//  DeleteKeychainUsecase.swift
//  PopPool
//
//  Created by Porori on 6/15/24.
//

import Foundation
import RxSwift

protocol DeleteKeychainUsecases {
    var keyChainRepository: KeyChainRepository { get set }
    
    /// 키체인에 저장된 JWT토큰을 호출합니다
    /// - Parameter key: 사용자의 id을 받습니다
    /// - Returns: 반환하는 값은 없습니다
    func deleteJwtToken(key: String) -> Completable
}
