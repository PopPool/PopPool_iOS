//
//  CommentRepository.swift
//  PopPool
//
//  Created by Porori on 9/24/24.
//

import Foundation
import RxSwift

final class CommentRepositoryImpl: CommentUseCase {
    
    private let provider = ProviderImpl()
    private let tokenInterceptor = TokenInterceptor()
    
    func createComment(request: CreateCommentRequestDTO) -> Completable {
        let endPoint = PopPoolAPIEndPoint.comment_postComment(request: request)
        return provider.request(with: endPoint, interceptor: tokenInterceptor)
    }
    
    func updateComment(request: UpdateCommentRequestDTO) -> Completable {
        let endPoint = PopPoolAPIEndPoint.comment_updateComments(request: request)
        return provider.request(with: endPoint, interceptor: tokenInterceptor)
    }
    
    func deleteComment(id: String, popUpId: Int64, commentId: Int64) -> Completable {
        let endPoint = PopPoolAPIEndPoint.comment_deleteComment(userId: id, popUpStoreId: popUpId, commentId: commentId)
        return provider.request(with: endPoint, interceptor: tokenInterceptor)
    }
    
}
