//
//  SignUpRepositoryImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/28/24.
//

import Foundation
import RxSwift

final class SignUpRepositoryImpl: SignUpRepository {
    
    let provider = AppDIContainer.shared.resolve(type: Provider.self)
    
    func checkNickName(nickName: String) -> Observable<Bool> {
        let endPoint = PopPoolAPIEndPoint.checkNickName(with: .init(nickName: nickName))
        return provider.requestData(with: endPoint, interceptor: TokenInterceptor())
    }
    
    func fetchInterestList() -> Observable<[Interest]> {
        let endPoint = PopPoolAPIEndPoint.fetchInterestList()
        return provider.requestData(with: endPoint, interceptor: TokenInterceptor()).map { responseDTO in
            return responseDTO.interestResponseList.map({ $0.toDomain() })
        }
    }
    
    func trySignUp(
        userId: String,
        nickName: String,
        gender: String,
        age: Int32,
        socialEmail: String?,
        socialType: String,
        interests: [Int]
    ) -> Completable {
        let endPoint = PopPoolAPIEndPoint.trySignUp(with: .init(
            userId: userId,
            nickName: nickName,
            gender: gender,
            age: age,
            socialEmail: socialEmail,
            socialType: socialType,
            interests: interests)
        )
        return provider.request(with: endPoint, interceptor: TokenInterceptor())
    }
}
