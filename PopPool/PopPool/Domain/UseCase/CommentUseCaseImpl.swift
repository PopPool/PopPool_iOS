//
//  CommentUseCaseImpl.swift
//  PopPool
//
//  Created by Porori on 9/24/24.
//

import Foundation
import RxSwift

class CommentUseCaseImpl: CommentUseCase {
    var repository: CommentRepository
    
    init(repository: CommentRepository) {
        self.repository = repository
    }
    
    func createComment(request: CreateCommentRequestDTO) -> Completable {
        return repository.postComment(request: request)
    }
    
    func updateComment(request: UpdateCommentRequestDTO) -> Completable {
        return repository.updateComment(request: request)
    }
    
    func deleteComment(id: String, popUpId: Int64, commentId: Int64) -> Completable {
        return repository.deleteComment(id: id, popUpId: popUpId, commentId: commentId)
    }
    
    
}
