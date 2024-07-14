//
//  LocalDeleteUseCaseImpl.swift
//  PopPool
//
//  Created by Porori on 7/4/24.
//

import Foundation
import RxSwift

final class DeleteLocalUseCaseImpl: DeleteLocalUseCase {
    
    var repository: LocalDBRepository
    
    init(repository: LocalDBRepository) {
        self.repository = repository
    }
    
    func execute(key: String) -> Completable {
        repository.delete(key: key)
    }
}
