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

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        print("TokenInterceptor - URL 요청 수정 시작: \(urlRequest.url?.absoluteString ?? "알 수 없음")")

        // URL 컴포넌트를 생성하여 기존 URL의 모든 부분을 유지
        guard var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false) else {
            completion(.failure(AFError.invalidURL(url: urlRequest.url!)))
            return
        }

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let keyChainService = KeyChainServiceImpl()

        keyChainService.fetchToken(type: .accessToken)
            .subscribe { accessToken in
                print("TokenInterceptor - 액세스 토큰 가져오기 성공: \(accessToken)")
                urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                print("TokenInterceptor - 헤더에 토큰 추가 완료")

                // 여기서 URL을 다시 설정하지 않고, 기존 URL을 그대로 사용합니다.
                print("TokenInterceptor - 최종 요청 URL: \(urlRequest.url?.absoluteString ?? "알 수 없음")")
                print("TokenInterceptor - 최종 요청 헤더: \(urlRequest.allHTTPHeaderFields ?? [:])")

                completion(.success(urlRequest))
            } onFailure: { error in
                print("TokenInterceptor - 토큰 가져오기 실패: \(error)")
                completion(.failure(error))
            }
            .disposed(by: disposeBag)
    }
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            print("TokenInterceptor - retry called for URL: \(request.request?.url?.absoluteString ?? "unknown")")

            return
        }

        let keyChainService = KeyChainServiceImpl()
        keyChainService.fetchToken(type: .refreshToken)
            .flatMap { refreshToken -> Single<String> in
                // 여기서 refreshToken으로 새 accessToken 요청하는 API 호출
                // 성공하면 새 accessToken 반환
                return Single.just("새로운 액세스 토큰") // 이 부분은 실제 API 호출로 대체해야 함
            }
            .subscribe(onSuccess: { newAccessToken in
                keyChainService.saveToken(type: .accessToken, value: newAccessToken)
                    .subscribe(onCompleted: {
                        print("TokenInterceptor - Token refreshed successfully")
                        completion(.retry)
                    }, onError: { _ in
                        completion(.doNotRetryWithError(error))
                    })
                    .disposed(by: self.disposeBag)
            }, onFailure: { _ in
                completion(.doNotRetryWithError(error))
            })
            .disposed(by: disposeBag)
    }
}
