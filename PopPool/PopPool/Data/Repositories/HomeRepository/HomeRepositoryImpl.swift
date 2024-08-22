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
    
    func fetchHome(userId: String) -> Observable<GetHomeInfoResponse> {
        let endPoint = PopPoolAPIEndPoint.home_fetchHome(userId: userId)
        return provider.requestData(with: endPoint).map({ $0.toDomain() })
    }
    
    func fetchPopular(userId: String) -> RxSwift.Observable<GetHomeInfoResponse> {
        let endPoint = PopPoolAPIEndPoint.home_fetchNewPopUp(userId: userId)
        return provider.requestData(with: endPoint).map({ $0.toDomain() })
    }
    
    func fetchNew(userId: String) -> RxSwift.Observable<GetHomeInfoResponse> {
        let endPoint = PopPoolAPIEndPoint.home_fetchNewPopUp(userId: userId)
        return provider.requestData(with: endPoint).map({ $0.toDomain() })
    }
    
    func fetchRecommended(userId: String) -> RxSwift.Observable<GetHomeInfoResponse> {
        let endPoint = PopPoolAPIEndPoint.home_fetchRecommendedPopUp(userId: userId)
        return provider.requestData(with: endPoint).map({ $0.toDomain() })
    }
}
