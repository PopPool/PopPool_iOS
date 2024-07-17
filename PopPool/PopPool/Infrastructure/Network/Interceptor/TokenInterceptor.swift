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
        
        // Request Header에 Token 추가
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

        // 응답 Header에서 Token 추출 코드 작성 필요
    }
}
