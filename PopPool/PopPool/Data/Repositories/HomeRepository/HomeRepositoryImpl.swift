//
//  HomeRepositoryImpl.swift
//  PopPool
//
//  Created by Porori on 8/21/24.
//

import Foundation
import RxSwift

final class HomeRepositoryImpl: HomeRepository {
    
    private let provider = AppDIContainer.shared.resolve(type: Provider.self)
    private let tokenInterceptor = TokenInterceptor()
    
    func fetchHome(
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]?
    ) -> Observable<GetHomeInfoResponse> {
        let endPoint = PopPoolAPIEndPoint.home_fetchHome(
            userId: userId,
            request: .init(userId: userId, page: page, size: size, sort: sort)
        )
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map({ $0.toDomain() })
    }
    
    func fetchPopular(userId: String) -> RxSwift.Observable<GetHomeInfoResponse> {
        let endPoint = PopPoolAPIEndPoint.home_fetchNewPopUp(userId: userId)
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map({ $0.toDomain() })
    }
    
    func fetchNew(userId: String) -> RxSwift.Observable<GetHomeInfoResponse> {
        let endPoint = PopPoolAPIEndPoint.home_fetchNewPopUp(userId: userId)
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map({ $0.toDomain() })
    }
    
    func fetchRecommended(userId: String) -> RxSwift.Observable<GetHomeInfoResponse> {
        let endPoint = PopPoolAPIEndPoint.home_fetchRecommendedPopUp(userId: userId)
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map({ $0.toDomain() })
    }
}
