//
//  LikeUseCaseImpl.swift
//  PopPool
//
//  Created by Porori on 10/3/24.
//

import Foundation
import RxSwift

final class LikeUseCaseImpl: LikeUseCase {
    var repository: LikeRepository
    
    init(repository: LikeRepository) {
        self.repository = repository
    }
    
    func incrementLike(userId: String, commentId: Int64) -> Completable {
        return repository.incrementLike(userId: userId, commentId: commentId)
    }
    
    func decrementLike(userId: String, commentId: Int64) -> Completable {
        return repository.decrementLike(userId: userId, commentId: commentId)
    }
}
