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
//                      print("TokenInterceptor - 토큰 추가됨: Bearer \(accessToken)")
//                      print("TokenInterceptor - 요청 헤더:")
                      urlRequest.allHTTPHeaderFields?.forEach { key, value in
//                          print("  \(key): \(value)")
                      }

                      completion(.success(urlRequest))
//                      print("TokenInterceptor - 요청 헤더:")

                  } onFailure: { error in
                      print("TokenInterceptor - 토큰 가져오기 실패: \(error)")
                      completion(.failure(error))
                  }
                  .disposed(by: disposeBag)
          }

    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
         print("TokenInterceptor - retry 시작")

        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 400 else {
             print("TokenInterceptor - 재시도 불필요: \(error)")
             completion(.doNotRetryWithError(error))
             return
         }

    }
}
