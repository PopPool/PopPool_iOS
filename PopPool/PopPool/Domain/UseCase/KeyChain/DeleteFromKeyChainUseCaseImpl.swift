//
//  DeleteFromKeyChainUseCaseImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/16/24.
//

import Foundation
import RxSwift

final class DeleteFromKeyChainUseCaseImpl: DeleteFromKeyChainUseCase {
    var repository: KeyChainRepository
    
    init(repository: KeyChainRepository) {
        self.repository = repository
    }
    
    func execute(service: KeyChainService, account: KeyChainAccount) -> Completable {
        return repository.delete(service: service.rawValue, account: account.rawValue)
    }
}
