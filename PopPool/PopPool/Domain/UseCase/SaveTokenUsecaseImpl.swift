//
//  SaveTokenUsecaseImpl.swift
//  PopPool
//
//  Created by Porori on 6/19/24.
//

import Foundation
import RxSwift

class SaveTokenUsecaseImpl: SaveTokenUsecase {
    private var repository: TokenRepository
    
    init(repository: TokenRepository) {
        self.repository = repository
    }
    
    func save(account: String, token: String) -> Completable {
        repository.save(account: account, token: token)
    }
    
    func fetch(account: String) -> Single<String> {
        repository.fetch(account: account)
    }
    
    func delete(account: String) -> Completable {
        repository.delete(account: account)
    }
}
