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
    let disposeBag = DisposeBag()
    
    func checkNickName(nickName: String, credential: MyAuthenticationCredential) -> Observable<Bool> {
        let endPoint = PopPoolAPIEndPoint.checkNickName(with: .init(nickName: nickName), credential: credential)
        return provider.requestData(with: endPoint)
    }
    
    func fetchInterestList(credential: MyAuthenticationCredential) -> Observable<[String]> {
        let endPoint = PopPoolAPIEndPoint.fetchInterestList(credential: credential)
        return provider.requestData(with: endPoint).map { responseDTO in
            return responseDTO.interestResponseList.map { response in
                response.interestName
            }
        }
    }
    
    func fetchGenders(credential: MyAuthenticationCredential) -> Observable<String> {
        let endPoint = PopPoolAPIEndPoint.fetchGenders(credential: credential)
        return provider.requestData(with: endPoint).map { responseDTO in
            return responseDTO.label
        }
    }
}
