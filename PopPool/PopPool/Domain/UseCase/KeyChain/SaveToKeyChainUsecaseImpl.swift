//
//  SaveToKeyChainUseCaseImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/16/24.
//

import Foundation
import RxSwift

final class SaveToKeyChainUseCaseImpl: SaveToKeyChainUseCase {
    var repository: KeyChainRepository
    
    init(repository: KeyChainRepository) {
        self.repository = repository
    }
    
    func execute(service: KeyChainService, account: KeyChainAccount, value: String) -> Completable {
        return repository.create(service: service.rawValue, account: account.rawValue, value: value)
    }
}
