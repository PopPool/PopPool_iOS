//
//  SaveToKeychainUsecaseImpl.swift
//  PopPool
//
//  Created by Porori on 6/15/24.
//

import Foundation
import RxSwift

/// 키체인에 저장하는 usecase입니다
/// 저장 메서드를 실행합니다
final class SaveToKeychainUseCaseImpl: SaveToKeychainUsecase {
    var keychainRepository: KeyChainRepository
    
    init(keychainRepository: KeyChainRepository) {
        self.keychainRepository = keychainRepository
    }
    
    func saveJwtToken(key: String, token: String) -> Completable {
        return keychainRepository.save(id: key, key: token)
    }
}
