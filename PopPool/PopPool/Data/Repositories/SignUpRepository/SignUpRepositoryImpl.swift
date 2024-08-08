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
        let endPoint = PopPoolAPIEndPoint.signUp_checkNickName(with: .init(nickName: nickName))
        return provider.requestData(with: endPoint, interceptor: TokenInterceptor())
    }
    
    func fetchCategoryList() -> Observable<[Category]> {
        let endPoint = PopPoolAPIEndPoint.signUp_getCategoryList()
        return provider.requestData(with: endPoint, interceptor: TokenInterceptor()).map { responseDTO in
            return responseDTO.categoryResponseList.map({ $0.toDomain() })
        }
    }
    
    func trySignUp(
        userId: String,
        nickName: String,
        gender: String,
        age: Int32,
        socialEmail: String?,
        socialType: String,
        interests: [Int64]
    ) -> Completable {
        let endPoint = PopPoolAPIEndPoint.signUp_trySignUp(with: .init(
            userId: userId,
            nickName: nickName,
            gender: gender,
            age: age,
            socialEmail: socialEmail,
            socialType: socialType,
            interestCategories: interests)
        )
        return provider.request(with: endPoint, interceptor: RequestTokenInterceptor())
    }
}
