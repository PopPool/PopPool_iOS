//
//  SignUpRepositoryImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/28/24.
//

import Foundation
import RxSwift

final class SignUpRepositoryImpl {
    
    let provider = AppDIContainer.shared.resolve(type: Provider.self)
    let disposeBag = DisposeBag()
    
//    func trySignUp(
//        userId: String,
//        nickName: String,
//        gender: String,
//        age: Int,
//        socialType: String,
//        interests: [String],
//        credential: MyAuthenticationCredential
//    ) {
//        let requestDTO = TrySignUpRequestDTO(
//            userId: userId,
//            nickName: nickName,
//            gender: gender,
//            age: age,
//            socialType: socialType,
//            interests: interests
//        )
//        let endPoint = PopPoolAPIEndPoint.trySignUp(user: requestDTO, credential: credential)
//        
//        return 
//    }
    
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
