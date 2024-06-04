//
//  Provider.swift
//  PopPool
//
//  Created by Porori on 6/2/24.
//

import Foundation
import RxSwift
import RxAlamofire

protocol Provider {
    /// 네트워크 요청을 수행하고 결과를 반환하는 메서드
    /// - Parameter endpoint: 요청 엔드포인트
    /// - Returns: 요청에 대한 결과를 Single로 반환
    func requestData<R: Decodable, E: RequesteResponsable>(with endpoint: E) -> Single<R> where R == E.Response
}

class ProviderImpl: Provider {
    
    func requestData<R: Decodable, E: RequesteResponsable>(with endpoint: E) -> Single<R> where R == E.Response {
        
        return Single.create { single in
            
            do {
                let urlRequest = try endpoint.getUrlRequest()
                
                let request = RxAlamofire.requestData(urlRequest)
                    .flatMap { (response, data) -> Single<Data> in
                        return self.checkError(with: data, response)
                    }
                    .flatMap { data -> Single<R> in
                        return self.decodeData(data: data)
                    }
                    .subscribe { decodeData in
                        single(.success(decodeData))
                    } onError: { error in
                        single(.failure(error))
                    }
                return Disposables.create {
                    request.dispose()
                }
            } catch {
                single(.failure(NetworkError.urlRequest(error)))
            }
            return Disposables.create()
        }
    }
    
    /// HTTP 응답 상태 코드 확인 및 처리
    /// - Parameters:
    ///   - data: 응답 데이터
    ///   - response: HTTP 응답
    /// - Returns: 응답 데이터를 Single로 반환
    private func checkError(with data: Data, _ response: HTTPURLResponse) -> Single<Data> {
        return Single<Data>.create { single in
            if (200...299).contains(response.statusCode) {
                single(.success(data))
            } else {
                single(.failure(NetworkError.invalidHttpStatusCode(response.statusCode)))
            }
            return Disposables.create()
        }
    }
    
    /// JSON 데이터 디코딩 처리
    /// - Parameter data: 디코딩할 데이터
    /// - Returns: 디코딩된 데이터를 Single로 반환
    private func decodeData<R: Decodable>(data: Data) -> Single<R> {
        return Single.create { single in
            do {
                let decodeData = try JSONDecoder().decode(R.self, from: data)
                single(.success(decodeData))
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}
