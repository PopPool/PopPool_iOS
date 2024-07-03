//
//  LocalSaveUseCaseImpl.swift
//  PopPool
//
//  Created by Porori on 6/19/24.
//

import Foundation
import RxSwift

final class LocalSaveUseCaseImpl: LocalDBUseCase {

    var repository: LocalDBRepository
    
    init(repository: LocalDBRepository) {
        self.repository = repository
    }
    
    func save(key: String, value: String) -> Completable {
        repository.save(key: key, value: value)
    }
    
    func fetch(key: String, from databaseType: String) -> RxSwift.Single<String> {
        repository.fetch(key: key, from: databaseType)
    }
    
    func delete(key: String, from database: String) -> Completable {
        repository.delete(key: key, from: database)
    }
}
