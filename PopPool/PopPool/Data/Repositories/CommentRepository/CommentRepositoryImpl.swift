//
//  CommentRepository.swift
//  PopPool
//
//  Created by Porori on 9/24/24.
//

import Foundation
import RxSwift

final class CommentRepositoryImpl: CommentRepository {
    
    private let provider = ProviderImpl()
    private let requestTokenInterceptor = RequestTokenInterceptor()

    func postComment(request: CreateCommentRequestDTO) -> RxSwift.Completable {
        let endPoint = PopPoolAPIEndPoint.comment_postComment(request: request)
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
    
    func updateComment(request: UpdateCommentRequestDTO) -> Completable {
        let endPoint = PopPoolAPIEndPoint.comment_updateComments(request: request)
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
    
    func deleteComment(id: String, popUpId: Int64, commentId: Int64) -> Completable {
        let endPoint = PopPoolAPIEndPoint.comment_deleteComment(userId: id, popUpStoreId: popUpId, commentId: commentId)
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
    
}
