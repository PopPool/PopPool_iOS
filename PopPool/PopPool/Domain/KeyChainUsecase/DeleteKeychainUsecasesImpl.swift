//
//  DeleteKeychainUsecasesImpl.swift
//  PopPool
//
//  Created by Porori on 6/14/24.
//

import Foundation
import RxSwift

/// 키체인에 있는 데이터를 삭제하는 usecase입니다
/// token을 삭제하는 메서드를 실행합니다
final class DeleteKeychainUseCase: DeleteKeychainUsecases {
    var keyChainRepository: KeyChainRepository
    
    init(keyChainRepository: KeyChainRepository) {
        self.keyChainRepository = keyChainRepository
    }
    
    func deleteJwtToken(key: String) -> Completable {
        return keyChainRepository.delete(id: key)
    }
}
