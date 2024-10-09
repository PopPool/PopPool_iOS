//
//  LikeRepositoryImpl.swift
//  PopPool
//
//  Created by Porori on 10/3/24.
//

import Foundation
import RxSwift

class LikeRepositoryImpl: LikeRepository {
    
    private let provider = AppDIContainer.shared.resolve(type: Provider.self)
    private let requestTokenInterceptor = TokenInterceptor()
    
    func incrementLike(userId: String, commentId: Int64) -> Completable {
        let endpoint = PopPoolAPIEndPoint.like_increment(userId: userId, commentId: commentId)
        return provider.request(with: endpoint, interceptor: requestTokenInterceptor)
    }
    
    func decrementLike(userId: String, commentId: Int64) -> Completable {
        let endpoint = PopPoolAPIEndPoint.like_delete(userId: userId, commentId: commentId)
        return provider.request(with: endpoint, interceptor: requestTokenInterceptor)
    }
}
