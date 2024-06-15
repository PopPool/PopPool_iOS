//
//  KeychainUsecases.swift
//  PopPool
//
//  Created by Porori on 6/14/24.
//

import Foundation
import RxSwift

/// 키체인에 저장하는 usecase입니다
/// 저장 메서드를 실행합니다
class SaveToKeychainUseCase {
    private let keychaingRepository: KeyChainRepository
    
    init(keychaingRepository: KeyChainRepository) {
        self.keychaingRepository = keychaingRepository
    }
    
    func saveJwtToken(ofKey: String, _ token: String) -> Completable {
        return keychaingRepository.save(id: ofKey, token: token)
    }
}

// 소셜별로 정리를 해야할까...
// 하나로 묶어야 하나
class fetchKeychainUseCase {
    private let keyChainRepository: KeyChainRepository
    
    init(keyChainRepository: KeyChainRepository) {
        self.keyChainRepository = keyChainRepository
    }
    
    func fetchJwtToken(user: KakaoUserCredentialResponse) -> Single<String?> {
        return keyChainRepository.fetchSavedToken(id: user.id)
    }
}

class deleteKeychainUseCase {
    private let keyChainRepository: KeyChainRepository
    
    init(keyChainRepository: KeyChainRepository) {
        self.keyChainRepository = keyChainRepository
    }
    
    func deleteJwtToken(of user: KakaoUserCredentialResponse) -> Completable {
        return keyChainRepository.delete(id: user.id)
    }
}
