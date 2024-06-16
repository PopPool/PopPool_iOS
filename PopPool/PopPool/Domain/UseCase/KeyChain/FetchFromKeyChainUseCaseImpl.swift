//
//  FetchFromKeyChainUseCaseImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/16/24.
//

import Foundation
import RxSwift

final class FetchFromKeyChainUseCaseImpl: FetchFromKeyChainUseCase {
    var repository: KeyChainRepository
    
    init(repository: KeyChainRepository) {
        self.repository = repository
    }
    
    func execute(service: KeyChainService, account: KeyChainAccount) -> Single<String> {
        return repository.fetch(service: service.rawValue, account: account.rawValue)
    }
}
