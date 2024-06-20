//
//  FetchTokenUsecaseImpl.swift
//  PopPool
//
//  Created by Porori on 6/19/24.
//

import Foundation
import RxSwift

class FetchTokenUseCaseImpl: LocalFetchUseCase {
    
    var repository: LocalDBRepository
    
    init(repository: LocalDBRepository) {
        self.repository = repository
    }
    
    func fetch(key: String, from databaseType: String) -> RxSwift.Single<String> {
        repository.fetch(key: key, from: databaseType)
    }
}
