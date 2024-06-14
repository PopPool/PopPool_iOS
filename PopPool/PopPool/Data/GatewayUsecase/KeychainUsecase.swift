//
//  KeychainUsecase.swift
//  PopPool
//
//  Created by Porori on 6/14/24.
//

import Foundation
import RxSwift

class SaveToKeychainUseCase {
    private let keychaingRepository: KeyChainRepository
    
    init(keychaingRepository: KeyChainRepository) {
        self.keychaingRepository = keychaingRepository
    }
    
    func execute(key: String, value: String) -> Completable {
        return keychaingRepository.save(key: key, value: value)
    }
}
