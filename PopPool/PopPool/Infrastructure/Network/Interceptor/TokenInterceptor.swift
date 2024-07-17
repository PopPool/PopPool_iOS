//
//  TokenInterceptor.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/9/24.
//

import Foundation
import Alamofire
import RxSwift

final class TokenInterceptor: RequestInterceptor {
    
    private var disposeBag = DisposeBag()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let keyChainService = KeyChainServiceImpl()
        keyChainService.fetchToken(type: .accessToken)
            .subscribe { accessToken in
                urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                completion(.success(urlRequest))
            } onFailure: { error in
                completion(.failure(error))
            }
            .disposed(by: disposeBag)
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        // TODO: - token refresh 코드
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
//        response.allHeaderFields

//        RefreshTokenAPI.refreshToken { result in
//            switch result {
//            case .success(let accessToken):
//                KeychainServiceImpl.shared.accessToken = accessToken
//                completion(.retry)
//            case .failure(let error):
//                completion(.doNotRetryWithError(error))
//            }
//        }
    }
}
