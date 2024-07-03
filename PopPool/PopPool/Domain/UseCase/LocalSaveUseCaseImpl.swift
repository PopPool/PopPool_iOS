//
//  LocalSaveUseCaseImpl.swift
//  PopPool
//
//  Created by Porori on 6/19/24.
//

import Foundation
import RxSwift

final class LocalSaveUseCaseImpl: LocalSaveUseCase {

    var repository: LocalDBRepository
    
    init(repository: LocalDBRepository) {
        self.repository = repository
    }
    
    func execute(key: String, value: String) -> Completable {
        repository.save(key: key, value: value)
    }
}
