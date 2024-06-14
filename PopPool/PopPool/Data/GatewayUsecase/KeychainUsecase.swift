//
//  KeychainUsecase.swift
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
    
    func execute(key: String, value: String) -> Completable {
        return keychaingRepository.save(key: key, value: value)
    }
}
